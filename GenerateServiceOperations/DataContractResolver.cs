using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using System.Xml;
using System.Reflection;

namespace GenerateServiceOperations
{
    [KnownAssembly("EAPI.dll")]
    class DataContractResolverShubert
    {
        DataContractSerializer serializer;
        StringBuilder buffer;

        public DataContractResolverShubert(Assembly assembly)
        {
            // Adding the DataContractResolver to the DataContractSerializer
            this.serializer = new DataContractSerializer(typeof(Object), null, int.MaxValue, false, true, null, new ApiDataContractResolver(assembly));
        }

        public string serialize(Type type)
        {
            try
            {
                Object instance = Activator.CreateInstance(type);
                this.buffer = new StringBuilder();

                using (XmlWriter xmlWriter = XmlWriter.Create(this.buffer))
                {
                    try
                    {
                        this.serializer.WriteObject(xmlWriter, instance);
                    }
                    catch (SerializationException error)
                    {
                        Console.WriteLine(error.ToString());
                    }
                }
                Console.WriteLine(this.buffer.ToString());
            }
            catch (Exception ex)
            {
                Console.WriteLine("Interface: {0} Error: {1} ", type.Name, ex.Message);
            }

            return (this.buffer.ToString());
        }
    }

    class ApiDataContractResolver : DataContractResolver
    {
        private Dictionary<string, XmlDictionaryString> dictionary = new Dictionary<string, XmlDictionaryString>();
        Assembly assembly;

        // Definition of the DataContractResolver
        public ApiDataContractResolver(Assembly assembly)
        {
            this.assembly = assembly;
        }

        // Used at deserialization
        // Allows users to map xsi:type name to any Type 
        public override Type ResolveName(string typeName, string typeNamespace, Type declaredType, DataContractResolver knownTypeResolver)
        {
            XmlDictionaryString tName;
            XmlDictionaryString tNamespace;
            if (dictionary.TryGetValue(typeName, out tName) && dictionary.TryGetValue(typeNamespace, out tNamespace))
            {
                return this.assembly.GetType(tNamespace.Value + "." + tName.Value);
            }
            else
            {
                return null;
            }
        }

        // Used at serialization
        // Maps any Type to a new xsi:type representation
        public override bool TryResolveType(Type type, Type declaredType, DataContractResolver knownTypeResolver, out XmlDictionaryString typeName, out XmlDictionaryString typeNamespace)
        {
            string name = type.Name;
            string namesp = type.Namespace;
            typeName = new XmlDictionaryString(XmlDictionary.Empty, name, 0);
            typeNamespace = new XmlDictionaryString(XmlDictionary.Empty, namesp, 0);
            if (!dictionary.ContainsKey(type.Name))
            {
                dictionary.Add(name, typeName);
            }
            if (!dictionary.ContainsKey(type.Namespace))
            {
                dictionary.Add(namesp, typeNamespace);
            }
            return true;
        }
    }

    [AttributeUsage(AttributeTargets.All)]
    class KnownAssembly : System.Attribute
    {
        public KnownAssembly(string name)
        {
            this.AssemblyName = name;
        }

        public string AssemblyName { get; set; }
    }

}
