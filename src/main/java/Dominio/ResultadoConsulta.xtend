package Dominio


	//import org.mongodb.morphia.annotations.Embedded
import org.mongodb.morphia.annotations.Property
import java.util.Set

import org.mongodb.morphia.annotations.Embedded
import java.util.Date
import org.mongodb.morphia.annotations.Id
import org.bson.types.ObjectId


class ResultadoConsulta {
	
	@Id ObjectId id
	
	@Property("aerolinea")
	String aerolinea
	
	@Property("llegada")
	Date llegada
	
	@Property("asientos libres")
	String libres 
	
	new(Vuelo vuelo){
	aerolinea =vuelo.aerolinea
	llegada = vuelo.fechaLlegada
	libres = vuelo.cantidadDeAsientosLibres.toString
	}
	

}