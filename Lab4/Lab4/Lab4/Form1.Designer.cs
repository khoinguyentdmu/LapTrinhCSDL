namespace Lab4
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnWriteDStoXML = new System.Windows.Forms.Button();
            this.btnReadXMLToDS = new System.Windows.Forms.Button();
            this.btnWriteXMLwithDiff = new System.Windows.Forms.Button();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // btnWriteDStoXML
            // 
            this.btnWriteDStoXML.Location = new System.Drawing.Point(28, 33);
            this.btnWriteDStoXML.Name = "btnWriteDStoXML";
            this.btnWriteDStoXML.Size = new System.Drawing.Size(125, 23);
            this.btnWriteDStoXML.TabIndex = 0;
            this.btnWriteDStoXML.Text = "WriteDataSetToXML";
            this.btnWriteDStoXML.UseVisualStyleBackColor = true;
            this.btnWriteDStoXML.Click += new System.EventHandler(this.btnWriteDStoXML_Click);
            // 
            // btnReadXMLToDS
            // 
            this.btnReadXMLToDS.Location = new System.Drawing.Point(159, 33);
            this.btnReadXMLToDS.Name = "btnReadXMLToDS";
            this.btnReadXMLToDS.Size = new System.Drawing.Size(125, 23);
            this.btnReadXMLToDS.TabIndex = 0;
            this.btnReadXMLToDS.Text = "ReadXMLToDataSet";
            this.btnReadXMLToDS.UseVisualStyleBackColor = true;
            this.btnReadXMLToDS.Click += new System.EventHandler(this.btnReadXMLToDS_Click);
            // 
            // btnWriteXMLwithDiff
            // 
            this.btnWriteXMLwithDiff.Location = new System.Drawing.Point(290, 33);
            this.btnWriteXMLwithDiff.Name = "btnWriteXMLwithDiff";
            this.btnWriteXMLwithDiff.Size = new System.Drawing.Size(125, 23);
            this.btnWriteXMLwithDiff.TabIndex = 0;
            this.btnWriteXMLwithDiff.Text = "WriteXMLwithDiff";
            this.btnWriteXMLwithDiff.UseVisualStyleBackColor = true;
            this.btnWriteXMLwithDiff.Click += new System.EventHandler(this.btnWriteXMLwithDiff_Click);
            // 
            // dataGridView1
            // 
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(28, 75);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(387, 171);
            this.dataGridView1.TabIndex = 1;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(451, 269);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.btnWriteXMLwithDiff);
            this.Controls.Add(this.btnReadXMLToDS);
            this.Controls.Add(this.btnWriteDStoXML);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Write Read XML to DataSet";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnWriteDStoXML;
        private System.Windows.Forms.Button btnReadXMLToDS;
        private System.Windows.Forms.Button btnWriteXMLwithDiff;
        private System.Windows.Forms.DataGridView dataGridView1;
    }
}

