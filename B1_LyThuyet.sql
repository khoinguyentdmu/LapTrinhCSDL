--1----------------------------------------------------------------------
GO
CREATE PROC sp_ThongtinDocGia (@ma_DocGia CHAR(4)) 
AS 
BEGIN
	-- Nếu "mã độc giả" là trẻ em
	IF EXISTS (SELECT 1 FROM TreEm WHERE TreEm.ma_DocGia = @ma_DocGia)
		SELECT * 
		FROM DocGia, TreEm
		WHERE TreEm.ma_DocGia = DocGia.ma_DocGia AND DocGia.ma_DocGia = @ma_DocGia
	ELSE
		SELECT * 
		FROM DocGia, NguoiLon
		WHERE NguoiLon.ma_DocGia = DocGia.ma_DocGia AND DocGia.ma_DocGia = @ma_DocGia
END

GO
EXEC sp_ThongtinDocGia 'D006'

--2----------------------------------------------------------------------
GO
CREATE PROC sp_ThongtinDausach
AS
BEGIN
	SELECT DauSach.isbn, DauSach.ma_tuasach, DauSach.ngonngu, DauSach.bia, DauSach.trangthai, TuaSach.ma_tuasach, TuaSach.tacgia, TuaSach.tomtat, TuaSach.tuasach, COUNT(CuonSach.ma_cuonsach) AS 'SL'
	FROM DauSach, CuonSach, TuaSach
	WHERE DauSach.isbn = CuonSach.isbn AND CuonSach.tinhtrang = 'yes' AND TuaSach.ma_tuasach = DauSach.ma_tuasach
	GROUP BY DauSach.isbn, DauSach.ma_tuasach, DauSach.ngonngu, DauSach.bia, DauSach.trangthai, TuaSach.ma_tuasach, TuaSach.tacgia, TuaSach.tomtat, TuaSach.tuasach
END

GO
EXEC sp_ThongtinDausach

--3----------------------------------------------------------------------
GO
CREATE PROC sp_ThongtinNguoilonDangmuon
AS
BEGIN
	SELECT DocGia.*, NguoiLon.*
	FROM DocGia, NguoiLon
	WHERE DocGia.ma_DocGia = NguoiLon.ma_DocGia AND DocGia.ma_DocGia IN (SELECT Muon.ma_DocGia FROM Muon)
END

GO
EXEC sp_ThongtinNguoilonDangmuon

--4----------------------------------------------------------------------
GO
CREATE PROC sp_ThongtinNguoilonQuahan
AS
BEGIN
	SELECT DocGia.*, NguoiLon.*
	FROM DocGia, NguoiLon
	WHERE DocGia.ma_DocGia = NguoiLon.ma_DocGia 
	AND DocGia.ma_DocGia IN (SELECT Muon.ma_DocGia FROM Muon WHERE Muon.ngay_hethan <= GETDATE())
END

GO
EXEC sp_ThongtinNguoilonQuahan

--5----------------------------------------------------------------------
GO
CREATE PROC sp_DocGiaCoTreEmMuon
AS
BEGIN
	SELECT DocGia.*, NguoiLon.*
	FROM DocGia, NguoiLon
	WHERE DocGia.ma_DocGia = NguoiLon.ma_DocGia 
	AND DocGia.ma_DocGia IN (SELECT Muon.ma_DocGia FROM Muon)	-- DS "mã đọc giả người lớn" mượn
	AND DocGia.ma_DocGia IN (
								-- DS "mã đọc giả người lớn có trẻ em mượn"
								SELECT TreEm.ma_DocGia_nguoilon FROM TreEm
								WHERE TreEm.ma_DocGia IN (
															SELECT Muon.ma_DocGia 
															FROM Muon
														)
							)
END

GO
EXEC sp_DocGiaCoTreEmMuon

--6----------------------------------------------------------------------
GO
CREATE PROC sp_CapnhatTrangthaiDausach (@isbn char(20))
AS
BEGIN
	DECLARE @SZ INT = (SELECT COUNT(*)
					FROM CuonSach
					WHERE CuonSach.isbn = @isbn AND CuonSach.tinhtrang = 'yes')
	-- Nếu không tồn tại cuốn sách nào trong thư viện
	IF @SZ = 0
		UPDATE DauSach
		SET DauSach.trangthai = 'no'
		WHERE DauSach.isbn = @isbn
	ELSE
		UPDATE DauSach
		SET DauSach.trangthai = 'yes'
		WHERE DauSach.isbn = @isbn
END

GO
EXEC sp_CapnhatTrangthaiDausach '5-421-41243-1       '

--7----------------------------------------------------------------------
GO
CREATE PROC sp_ThemTuaSach (@tuasach NVARCHAR(50), @tacgia NVARCHAR(50), @tomtat NVARCHAR(50))
AS
BEGIN

	-- Tìm mã tựa sách rỗng
	DECLARE @val CHAR(4), @index INT = 1
	WHILE (1 = 1)
	BEGIN
		SET @val = 'T' + (SELECT RIGHT('00' + CONVERT (VARCHAR, @index), 3))
		-- Nếu tồn tại mã sách rỗng
		IF NOT EXISTS (SELECT 1 FROM TuaSach WHERE TuaSach.ma_tuasach = @val)
			BREAK
		SET @index = @index + 1
	END

	-- Nếu tồn tại bộ 3 thông tin trong CSDL
	IF EXISTS	(
					SELECT 1
					FROM TuaSach
					WHERE TuaSach.tuasach = @tuasach AND TuaSach.tacgia = @tacgia AND TuaSach.tomtat = @tomtat
				)
		PRINT ('Trùng tựa sách rồi!!')
	ELSE
		INSERT INTO TuaSach VALUES (@val, @tuasach, @tacgia, @tomtat)
END

GO
EXEC sp_ThemTuaSach '22s', '2', '3'

--8----------------------------------------------------------------------
GO
CREATE PROC sp_ThemCuonSach (@isbn char(20))
AS
BEGIN
	-- Nếu không tồn tại mã isbn phù hợp
	IF NOT EXISTS (
					SELECT 1
					FROM DauSach
					WHERE DauSach.isbn = @isbn)
		BEGIN
			PRINT('Không tồn tại mã isbn trong CSDL đầu sách')
			RETURN
		END

	-- Tìm ID rỗng
	DECLARE @val CHAR(4), @index INT = 1
	WHILE (1 = 1)
	BEGIN
		SET @val = 'S' + (SELECT RIGHT('00' + CONVERT (VARCHAR, @index), 3))
		-- Nếu tồn tại cuốn sách rỗng
		IF NOT EXISTS (SELECT 1 FROM CuonSach WHERE CuonSach.ma_cuonsach = @val)
			BREAK
		SET @index = @index + 1
	END

	INSERT INTO CuonSach VALUES (@isbn, @val, 'yes')
	
	UPDATE DauSach
	SET DauSach.trangthai = 'yes'
	WHERE DauSach.isbn = @isbn
END

GO
EXEC sp_ThemCuonSach '0-471-41743-1       '


--9----------------------------------------------------------------------
GO
CREATE PROC sp_ThemNguoiLon (@ho NVARCHAR(20), @tenlot NVARCHAR(30), @ten NVARCHAR(20), 
			@ngaysinh DATETIME, @sonha CHAR(10), @duong NVARCHAR(30), @quan NVARCHAR(20), 
			@dienthoai CHAR(15), @han_sd DATETIME)
AS
BEGIN
	-- Tìm mã đọc giả rỗng
	DECLARE @val CHAR(4), @index INT = 1
	WHILE (1 = 1)
	BEGIN
		SET @val = 'D' + (SELECT RIGHT('00' + CONVERT (VARCHAR, @index), 3))
		-- Nếu tồn tại đọc giả rỗng
		IF NOT EXISTS (SELECT 1 FROM DocGia WHERE DocGia.ma_DocGia = @val)
			BREAK
		SET @index = @index + 1
	END
	
	-- Nếu dưới 18 tuổi
	IF DATEDIFF(YEAR, @ngaysinh, GETDATE()) < 18
	BEGIN
		PRINT('Đọc giả này chưa đủ tuổi. Không thể sử dụng Stored Procedure này')
		RETURN
	END

	-- Thêm đọc giả người lớn
	INSERT INTO DocGia VALUES (@val, @ho, @tenlot, @ten, @ngaysinh)
	INSERT INTO NguoiLon VALUES (@val, @sonha, @duong, @quan, @dienthoai, @han_sd)
END

GO
EXEC sp_ThemNguoiLon 'd', 'd', 'd', '2005-10-10', '2', '2', '2', '4', '2018-10-10'

--10----------------------------------------------------------------------
GO
CREATE PROC sp_ThemTreEm (@ho NVARCHAR(20), @tenlot NVARCHAR(30), @ten NVARCHAR(20), 
			@ngaysinh DATETIME, @ma_DocGia_nguoilon char(4))
AS
BEGIN
	--Tìm mã đọc giả rỗng
	DECLARE @val CHAR(4), @index INT = 1
	WHILE (1 = 1)
	BEGIN
		SET @val = 'D' + (SELECT RIGHT('00' + CONVERT (VARCHAR, @index), 3))
		-- Nếu tồn tại đọc giả rỗng
		IF NOT EXISTS (SELECT 1 FROM DocGia WHERE DocGia.ma_DocGia = @val)
			BREAK
		SET @index = @index + 1
	END

	-- Nếu trên 18 tuổi
	IF DATEDIFF(YEAR, @ngaysinh, GETDATE()) >= 18
	BEGIN
		PRINT('Đọc giả này là người lớn. Không thể sử dụng Stored Procedure này')
		RETURN
	END

	-- Nếu mã đọc giả người lớn không hợp lệ
	IF NOT EXISTS (SELECT 1 FROM NguoiLon WHERE NguoiLon.ma_DocGia = @ma_DocGia_nguoilon)
	BEGIN
		PRINT('Mã đọc giả người lớn không đúng')
		RETURN
	END

	DECLARE @CNT INT = (SELECT COUNT(*) FROM NguoiLon, TreEm WHERE NguoiLon.ma_DocGia = TreEm.ma_DocGia_nguoilon AND NguoiLon.ma_DocGia = @ma_DocGia_nguoilon)

	-- Môi đọc giả chỉ bảo lãnh tối đa 2 trẻ em
	IF (@CNT = 2)
	BEGIN
		PRINT('Một đọc giả người lớn không thể bảo lãnh nhiều hơn 2 trẻ em')
		RETURN
	END
	

	--Thêm đọc giả trẻ em
	INSERT INTO DocGia VALUES (@val, @ho, @tenlot, @ten, @ngaysinh)
	INSERT INTO TreEm VALUES (@val, @ma_DocGia_nguoilon)
END

GO
EXEC sp_ThemTreEm 'd', 'd', 'd', '2006-10-10', 'D011'

--11----------------------------------------------------------------------
GO
CREATE PROC sp_XoaDocGia(@madocgia CHAR(4))
AS
BEGIN
BEGIN TRAN
	DECLARE @temp CHAR(4) -- biến tạm
	-- Kiểm tra độc giả có tồn tại hay không
	IF NOT EXISTS (SELECT 1 FROM dbo.DocGia WHERE ma_DocGia = @madocgia)
	BEGIN
	    PRINT('Đọc giả không tồn tại!')
		RETURN
	END
	-- Kiểm tra đọc giả có mượn sách hay không
	IF EXISTS (SELECT 1 FROM dbo.Muon WHERE ma_DocGia = @madocgia)
	BEGIN
	    PRINT('Độc giả này đang mượn sách, không thể xóa!')
		ROLLBACK TRAN
		RETURN
	END
	-- Kiểm tra mã đọc giả có phải là người lớn
	IF EXISTS (SELECT 1 FROM dbo.NguoiLon WHERE ma_DocGia = @madocgia)
	BEGIN
		-- Kiểm tra đọc giả có bảo lãnh trẻ em nào hay không
	    IF EXISTS (SELECT 1 FROM dbo.TreEm WHERE ma_DocGia_nguoilon = @madocgia)
		BEGIN
		    WHILE EXISTS (SELECT 1 FROM dbo.TreEm WHERE ma_DocGia_nguoilon = @madocgia)
			BEGIN
				SELECT TOP 1 @temp = ma_DocGia FROM dbo.TreEm WHERE ma_DocGia_nguoilon = @madocgia
			    EXEC dbo.sp_XoaDocGia @madocgia = @temp -- char(4)
			END
		END
		DELETE FROM dbo.NguoiLon WHERE ma_DocGia = @madocgia
	END
	ELSE -- Nếu đọc giả là trẻ em
	BEGIN
	    DELETE FROM dbo.TreEm WHERE ma_DocGia = @madocgia
	END
	-- Xóa dữ liệu các bảng còn lại liên quan
	DELETE FROM dbo.QuaTrinhMuon WHERE ma_DocGia = @madocgia
	DELETE FROM dbo.DangKy WHERE ma_DocGia = @madocgia
	DELETE FROM dbo.DocGia WHERE ma_DocGia = @madocgia
COMMIT
END

GO
-- EXEC dbo.sp_XoaDocGia @madocgia = 'D010' -- char(4)

--12----------------------------------------------------------------------


--13----------------------------------------------------------------------
-- Câu này dữ liệu đề bài hơi mơ hồ nên cách làm sẽ mơ hồ theo
CREATE PROC sp_TraSach (@isbn CHAR(20), @ma_cuonsach CHAR(4), @ma_DocGia CHAR(4))
AS
BEGIN
	DECLARE @ngay_muon DATETIME, @ngay_hethan DATETIME

	-- Lấy thông tin ngày mượn, ngày trả và "kiểm tra có đúng đọc giả mượn sách"
	SELECT @ngay_muon = Muon.ngay_muon, @ngay_hethan = Muon.ngay_hethan FROM Muon WHERE Muon.isbn = @isbn AND Muon.ma_cuonsach = @ma_cuonsach AND Muon.ma_DocGia = @ma_DocGia
	PRINT(@ngay_muon)
	PRINT(@ngay_hethan)
	IF (@ngay_muon IS NULL)
	BEGIN
		PRINT('Không tồn tại')
		RETURN
	END

	-- Giả sử tiền mượn là 5000/cuốn, đặt cọc 1000
	DECLARE @tien_muon INT = 5000, @tien_datcoc INT = 1000, @tien_quahan INT = 1000, @tien_datra INT, @songay_quahan INT
	DECLARE @ngay_tra DATETIME = GETDATE()

	SET @songay_quahan = DATEDIFF(day, @ngay_hethan, @ngay_tra)

	-- Nếu mượn quá hạn
	IF @songay_quahan>0
	BEGIN
		SET @tien_muon = @tien_muon + @tien_quahan*@songay_quahan
	END

	-- Giả sử tiền đã trả :))
	SET @tien_datra = @tien_muon - @tien_datcoc

	-- Thêm và xóa 
	INSERT INTO QuaTrinhMuon VALUES (@isbn, @ma_cuonsach, @ngay_muon, @ma_DocGia, @ngay_hethan, @ngay_tra, @tien_muon, @tien_datra, @tien_datcoc, null)
	DELETE Muon
	WHERE Muon.isbn =@isbn AND Muon.ma_cuonsach = @ma_cuonsach
END

<<<<<<< HEAD
--14-------------------------------------------------------------
=======
--14----------------------------------------------------------------------
GO
>>>>>>> b6c5a4ca216dac1e9818274ee207898b02fb8332
CREATE TRIGGER tg_delMuon ON Muon
FOR DELETE 
AS
BEGIN
	DECLARE @ma_cuonsach CHAR(4) = (SELECT deleted.ma_cuonsach FROM deleted)
	UPDATE CuonSach
	SET CuonSach.tinhtrang = 'yes'
	WHERE CuonSach.ma_cuonsach = @ma_cuonsach
END

--15----------------------------------------------------------------------
GO
CREATE TRIGGER tg_insMuon ON Muon
FOR INSERT
AS
BEGIN
	DECLARE @ma_cuonsach CHAR(4) = (SELECT inserted.ma_cuonsach FROM inserted)
	UPDATE CuonSach
	SET CuonSach.tinhtrang = 'no'
	WHERE CuonSach.ma_cuonsach = @ma_cuonsach
END

--16----------------------------------------------------------------------
<<<<<<< HEAD
=======
GO
>>>>>>> b6c5a4ca216dac1e9818274ee207898b02fb8332
CREATE TRIGGER tg_updCuonSachUPDATE ON CuonSach
FOR UPDATE
AS
BEGIN
	DECLARE @CNT INT, @isbn CHAR(20) = (SELECT inserted.isbn FROM inserted)
	SET @CNT = (SELECT COUNT(*) FROM CuonSach WHERE CuonSach.isbn = @isbn AND CuonSach.tinhtrang = 'yes')
	IF (@CNT = 0)
		UPDATE DauSach
		SET DauSach.trangthai = 'no'
		WHERE DauSach.isbn = @isbn
	ELSE
		UPDATE DauSach
		SET DauSach.trangthai = 'yes'
		WHERE DauSach.isbn = @isbn
END