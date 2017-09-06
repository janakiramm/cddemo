using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

// For more information on enabling Web API for empty projects, visit http://go.microsoft.com/fwlink/?LinkID=397860

namespace DSLibrary
{
    [Route("api/[controller]")]
    public class LibraryAPI : Controller
    {
        LibraryDetails[] LibraryDetails = new LibraryDetails[]
        {
            new LibraryDetails { Id=1, BookName="Hands-on Programming with R", Author="Garrett", Category="R" },
            new LibraryDetails { Id=2, BookName="Mastering Python for Data Science", Author="Samir Madhavan", Category="Python" },
            new LibraryDetails { Id=3, BookName="Python for Data Analysis", Author="W Mckinney", Category="Python" },
            new LibraryDetails { Id=4, BookName="R for Everyone: Advanced Analytics and Graphics", Author="Jared P. Lander", Category="R" },
            new LibraryDetails { Id=5, BookName="R Graphics Cookbook", Author="Winston Chang", Category="R" }
        };

        // GET: api/values
        [HttpGet]
        public IEnumerable<LibraryDetails> GetAllBooks()
        {
            return LibraryDetails;
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public IActionResult Get(int id)
        {
            var books = LibraryDetails.FirstOrDefault((p) => p.Id == id);

            var item = books;
            if (item == null)
            {
                return NotFound();
            }
            return new ObjectResult(item);
        }
        
        // POST api/values
        [HttpPost]
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
