using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using System.Xml;
using System.Reflection;
using System.IO;
using System.Diagnostics;

namespace ServiceContractDataResolver
{
    [KnownAssembly("EAPI.dll")]
    public class ServiceContractDataResolver
    {
        DataContractSerializer serializer;
        StringBuilder buffer;
        public Dictionary<string, XmlDictionaryString> typeDictionary = new Dictionary<string, XmlDictionaryString>();

        public ServiceContractDataResolver(Assembly assembly, Dictionary<string, XmlDictionaryString> typeDictionary)
        {
            // Adding the DataContractResolver to the DataContractSerializer
            this.serializer = new DataContractSerializer(typeof(Object), null, int.MaxValue, false, true, null, new ApiDataContractResolver(assembly, typeDictionary));
        }

        public Dictionary<string, XmlDictionaryString> GetTypeDictionary()
        {
            return this.typeDictionary;
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

        public object deserialize(Type type, string xml)
        {
            using (XmlReader xmlReader = XmlReader.Create(new StringReader(xml)))
            {
                try
                {
                    Object obj = this.serializer.ReadObject(xmlReader);
                    return obj;
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error: {0}", ex.Message);
                    return null;
                }
            }
        }
    }

    class ApiDataContractResolver : DataContractResolver
    {
        private Dictionary<string, XmlDictionaryString> dictionary;
        Assembly assembly;

        // Definition of the DataContractResolver
        public ApiDataContractResolver(Assembly assembly, Dictionary<string, XmlDictionaryString> d)
        {
            Debugger.Break();
            this.assembly = assembly;
            this.dictionary = d;
        }

        // Used at deserialization
        // Allows users to map xsi:type name to any Type 
        public override Type ResolveName(string typeName, string typeNamespace, Type declaredType, DataContractResolver knownTypeResolver)
        {
            XmlDictionaryString tName;
            XmlDictionaryString tNamespace;

            Debugger.Break();

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
