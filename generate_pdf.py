from fpdf import FPDF

source_text_file = "lorem_ipsum.txt"
target_pdf_file  = "lorem_ipsum.pdf"

pdf = FPDF()

pdf.add_page()
pdf.set_font("Arial", size=12)

# To add a single line of text
pdf.cell(200, 10, txt="This is a line of text.", ln=True, align='C')

# To add text from a file
with open(source_text_file, "r") as f:
    for line in f:
        pdf.multi_cell(0, 10, txt=line) # multi_cell handles line breaks automatically

pdf.output(target_pdf_file)
