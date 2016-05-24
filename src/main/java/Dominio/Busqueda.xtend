package Dominio

import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.Observable
import org.mongodb.morphia.annotations.Entity
import org.mongodb.morphia.annotations.Id
import org.bson.types.ObjectId
import org.mongodb.morphia.annotations.Property

@Entity("consultas")
@Observable
@Accessors
class Busqueda {

@Id ObjectId id

    @Property("fecha")	
	Date fechaRealizacion

	transient public Usuario quienBusca

	public Set<Vuelo> resultados = newHashSet

	@Property("origen")
	Aeropuerto origen

	@Property("destino")
	Aeropuerto destino

	@Property("fechaDesde")
	Date desdeFecha

	@Property("fechaHasta")
	Date hastaFecha

	@Property("maxPrecio")
	Double maxPrecio

	transient static SimpleDateFormat dateToString = new SimpleDateFormat("dd/MM/yyyy - hh:mm 'hs'")
	
	new(Aeropuerto inicio, Aeropuerto fin, Date desde, Date hasta, Double max, Usuario usr) {
		origen = inicio
		destino = fin
		desdeFecha = desde
		hastaFecha = hasta
		maxPrecio = max
		quienBusca = usr
		fechaRealizacion = Calendar.getInstance.getTime
	}

	def validacionFecha() {
		if (desdeFecha != null && hastaFecha != null) {
			if (desdeFecha > hastaFecha) {
				throw new UserException("La 'Fecha Desde' no puede ser menor que 'Fecha Hasta' ")
			}
		}
	}

	def realizadoPor(Usuario unUsr) {
		quienBusca == unUsr
	}
	
	def getCriterioDeBusqueda(){
		var String criterio = "Se buscaron vuelos que cumplan con:"
		
		if(origen != null){criterio += " haber partido de " + origen}
		if(destino != null){criterio += " tener como destino " + destino}
		if(desdeFecha != null){criterio += " salir despues del " + dateToString.format(desdeFecha)}
		if(hastaFecha != null){criterio += " llegar antes del " + dateToString.format(hastaFecha)}
		if(maxPrecio != null){criterio += " pagar menos que " + maxPrecio}
		if(criterio.equals("Se buscaron vuelos que cumplan con:")){criterio = "Se buscaron todos los vuelos"}
		criterio
	}
	
	def getCantidadDeResultados(){
		resultados.size()
	}
	
	def getFechaRealizacionStr(){
		dateToString.format(fechaRealizacion)
	}
}
