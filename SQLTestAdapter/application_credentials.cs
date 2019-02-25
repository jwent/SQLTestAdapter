namespace SQLTestAdapter
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class application_credentials
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int credentials_functions_id { get; set; }

        [StringLength(50)]
        public string credentials_functions_1 { get; set; }

        [StringLength(50)]
        public string credentials_functions_2 { get; set; }

        [StringLength(50)]
        public string credentials_functions_3 { get; set; }
    }
}
