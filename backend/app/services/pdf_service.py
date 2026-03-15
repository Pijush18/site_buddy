from fpdf import FPDF
from datetime import datetime
import os

class PDFReportGenerator:
    def generate_calculation_report(self, calc_type: str, input_data: dict, result_data: dict):
        pdf = FPDF()
        pdf.add_page()
        
        # Header
        pdf.set_font("Arial", 'B', 16)
        pdf.cell(190, 10, f"SiteBuddy Engineering Report - {calc_type.capitalize()}", ln=True, align='C')
        pdf.set_font("Arial", '', 12)
        pdf.cell(190, 10, f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", ln=True, align='C')
        pdf.ln(10)
        
        # Input Section
        pdf.set_font("Arial", 'B', 14)
        pdf.cell(190, 10, "Input Parameters", ln=True)
        pdf.set_font("Arial", '', 12)
        for key, value in input_data.items():
            if key != 'generate_report' and key != 'project_id':
                pdf.cell(90, 8, f"{key.replace('_', ' ').capitalize()}:", border=0)
                pdf.cell(90, 8, f"{value}", border=0, ln=True)
        pdf.ln(5)
        
        # Results Section
        pdf.set_font("Arial", 'B', 14)
        pdf.cell(190, 10, "Calculation Results", ln=True)
        pdf.set_font("Arial", '', 12)
        for key, value in result_data.items():
            pdf.cell(90, 8, f"{key.replace('_', ' ').capitalize()}:", border=0)
            pdf.cell(90, 8, f"{value}", border=0, ln=True)
            
        # Footer
        pdf.set_y(-30)
        pdf.set_font("Arial", 'I', 8)
        pdf.cell(0, 10, "This is a computer-generated report via SiteBuddy Backend Engine.", align='C')
        
        # Save to temp file
        temp_path = f"/tmp/report_{calc_type}_{datetime.now().timestamp()}.pdf"
        pdf.output(temp_path)
        return temp_path
