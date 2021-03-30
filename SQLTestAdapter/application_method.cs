namespace SQLTestAdapter
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class application_method
    {
        [Key]
        public int application_method_id { get; set; }

        public int application_id { get; set; }

        public int application_version_id { get; set; }

        [Required]
        [StringLength(50)]
        public string method_name { get; set; }

        [StringLength(50)]
        public string return_type { get; set; }
    }
}
