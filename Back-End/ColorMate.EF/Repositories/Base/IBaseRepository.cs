using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.EF.Repositories.Base
{
    public interface IBaseRepository<T> where T : class
    {
        T GetById(int id);

        IEnumerable<T> GetAll();
        IQueryable<T> GetAllQueryable();

        T Add(T entity);

        T Update(T entity);

        void Delete(T entity);

    }
}
