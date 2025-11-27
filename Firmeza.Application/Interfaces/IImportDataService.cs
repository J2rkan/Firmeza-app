using Firmeza.Application.ViewModels;

namespace Firmeza.Application.Interfaces
{
    
    public interface IImportDataService
    {
        
        Task<ImportLogViewModel> ImportDataAsync(Stream fileStream);
    }
}
/// coment 