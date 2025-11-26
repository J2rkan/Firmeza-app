using Firmeza.Core.Interfaces;
using OfficeOpenXml;

namespace Firmeza.Infrastructure.Services
{
    public class ExcelParserService : IExcelParserService
    {
        
        public ExcelParserService()
        {
            // Configurar EPPlus para uso no comercial personal (EPPlus 8+)
            ExcelPackage.License.SetNonCommercialPersonal("Firmeza App");
        }

        public async Task<List<Dictionary<string, string>>> ParseExcelDataAsync(Stream fileStream)
        {
            var data = new List<Dictionary<string, string>>();

            using (var package = new ExcelPackage(fileStream))
            {
                // Asumimos que los datos están en la primera hoja
                var worksheet = package.Workbook.Worksheets[0];
                int rowCount = worksheet.Dimension.Rows;
                int colCount = worksheet.Dimension.Columns;

                // Suponemos que la fila 1 contiene los encabezados (ej: 'ProductName', 'ClientName')
                var headers = new List<string>();
                for (int col = 1; col <= colCount; col++)
                {
                    headers.Add(worksheet.Cells[1, col].Value?.ToString() ?? $"Column{col}");
                }

                // Recorrer las filas de datos (empezando por la fila 2)
                for (int row = 2; row <= rowCount; row++)
                {
                    var rowData = new Dictionary<string, string>();
                    for (int col = 1; col <= colCount; col++)
                    {
                        // Se guarda la data cruda, sin normalizar
                        rowData[headers[col - 1]] = worksheet.Cells[row, col].Value?.ToString() ?? string.Empty;
                    }
                    data.Add(rowData);
                }
            }
            return data;
        }
    }
}