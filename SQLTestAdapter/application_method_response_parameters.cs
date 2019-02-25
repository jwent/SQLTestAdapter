namespace SQLTestAdapter
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class application_method_response_parameters
    {
        [Key]
        public int application_method_response_id { get; set; }

        public int application_method_id { get; set; }

        [StringLength(50)]
        public string application_method_response_parameter_name { get; set; }

        public int? is_container { get; set; }

        public int? position { get; set; }

        public string value { get; set; }
    }
}
