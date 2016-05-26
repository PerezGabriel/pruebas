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
import java.util.ArrayList
import java.lang.reflect.Modifier
import java.util.List
import org.mongodb.morphia.query.UpdateOperations
import Dominio.Consulta

class LogsRepository<T>{
	private Datastore ds
	Morphia morphia
	
new() {
		val mongo = new MongoClient("localhost", 27017)
	    ds = new DatastoreImpl(new Morphia,mongo,"local")
	    //ds.save("Hola Mundo")	
	    
	
		//var coleccion = mongo.getDatabase("base").getCollection("prueba")
		//var documento = new BasicDBObject().append("1",Consulta)
		//coleccion.save(documento)
	}
	
	//def Class<T> insertarConsulta(Class<T> obj){
    def T insertarConsulta(T obj){
		//create(t )
		//val obj = despejarCampos(t)
		
		ds.save(obj)
		obj
	}
	
	def T getByExample(T example) {
		val result = searchByExample(example)
		if (result.isEmpty) {
			return null
		} else {
			return result.get(0)
		}
	}

	def List<T> searchByExample(T t){}

	/*def T createIfNotExists(T t) {
		val entidadAModificar = getByExample(t)
		if (entidadAModificar != null) {
			return entidadAModificar
		}
		create(t)
	}*/

	def void update(T t) {
		val result = ds.update(t, this.defineUpdateOperations(t))
		println("Actualizamos " + t + "? " + result.updatedExisting)
	}

    def UpdateOperations<T> defineUpdateOperations(T t){
    	
    }

	def Class<T> create(Class<T> t) {
		val obj = despejarCampos(t)
		ds.save(obj)
		obj
	}

	def Class<T> despejarCampos(Class<T> t) {
		val fields = new ArrayList(t.class.getDeclaredFields)
		val camposAModificar = fields.filter
[!Modifier.isTransient(it.modifiers)]
		val result = t.class.newInstance 
		camposAModificar.forEach [
			it.accessible = true
			var valor = it.get(t)
			if (valor != null) {
				try {
					valor.class.getDeclaredField("changeSupport")
					valor = despejarCampos(valor as Class<T>)
				} catch (NoSuchFieldException e) {
					// todo ok, no es un valor que tenga changeSupport
				}
			}
			it.set(result, valor)
		]
		result
	}

	def void delete(T t) {
		ds.delete(t)
	}

	def List<T> allInstances() {
		ds.createQuery(this.getEntityType()).asList
	}

	
    def Class<T> getEntityType(){}

	
	
	
	

}