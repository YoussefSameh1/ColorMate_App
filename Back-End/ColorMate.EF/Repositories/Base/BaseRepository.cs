using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace ColorMate.EF.Repositories.Base
{
    public class BaseRepository<T> : IBaseRepository<T> where T : class
    {
        protected ApplicationDbContext _context;
        public BaseRepository(ApplicationDbContext context)
        {
            _context = context;
        }


        public T GetById(int id)
        {
            return _context.Set<T>().Find(id);
        }


        public IEnumerable<T> GetAll()
        {
            return _context.Set<T>().ToList();
        }

        public IQueryable<T> GetAllQueryable()
        {
            return _context.Set<T>();
        }

        public T Add(T entity)
        {
            _context.Set<T>().Add(entity);
            return entity;
        }


        public T Update(T entity)
        {
            _context.Set<T>().Update(entity);
            return entity;
        }

        public void Delete(T entity)
        {
            _context.Set<T>().Remove(entity);
        }
    }
}
