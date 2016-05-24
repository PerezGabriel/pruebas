package Repositorios

import org.mongodb.morphia.Datastore
import org.mongodb.morphia.Morphia
import com.mongodb.MongoClient
import Dominio.Busqueda
import com.mongodb.BasicDBObject
import com.mongodb.DBObject
import com.mongodb.DB
import com.mongodb.DBCollection
import org.mongodb.morphia.DatastoreImpl

class LogsRepository {
	private Datastore ds
	Morphia morphia
	
new() {
		val mongo = new MongoClient("localhost", 27017)
	    ds = new DatastoreImpl(new Morphia,mongo,"local")
	    ds.save("Hola Mundo")	
	    
	
		//var coleccion = mongo.getDatabase("base").getCollection("prueba")
		//var documento = new BasicDBObject().append("Hola Mundo",String)
		//coleccion.save(documento)
	}
	
	def void insertarConsulta(Busqueda busqueda){
		ds.save(busqueda)
	}

}