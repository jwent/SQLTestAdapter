namespace SQLTestAdapter
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class TestAutomation : DbContext
    {
        public TestAutomation()
            : base("name=TestAutomation")
        {
        }

        public virtual DbSet<application_method> application_method { get; set; }
        public virtual DbSet<application_method_parameters> application_method_parameters { get; set; }
        public virtual DbSet<application_method_response_parameters> application_method_response_parameters { get; set; }
        public virtual DbSet<application_credentials> application_credentials { get; set; }
        public virtual DbSet<reflection_type_filter> reflection_type_filter { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<application_method>()
                .Property(e => e.method_name)
                .IsUnicode(false);

            modelBuilder.Entity<application_method>()
                .Property(e => e.return_type)
                .IsUnicode(false);
        }
    }
}
