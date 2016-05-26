package AppModel

import Dominio.Aeropuerto
import Dominio.Busqueda
import Dominio.Usuario
import Dominio.Vuelo
import Repositorios.AeropuertosRepositorio
import Repositorios.BusquedasRepositorio
import Repositorios.VuelosRepositorio
import java.util.ArrayList
import java.util.Date
import java.util.List
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable
import Repositorios.LogsRepository
import Dominio.Consulta

@Accessors
@Observable	
class BusquedaVueloAppModel {
	
	Usuario usr	
	List <Aeropuerto> todosLosAeropuertos = new ArrayList<Aeropuerto>
	
	Aeropuerto origen
	Aeropuerto destino
	Date fechaDesde
	Date fechaHasta
	Integer tarifaMax
	
	Vuelo vueloSeleccionado
	Set <Vuelo> resultados = null
	
	new (Usuario unUsr){
		usr = unUsr
		todosLosAeropuertos = AeropuertosRepositorio.getInstance.allInstances
	}

	def buscar() {
		var Double precioMaximo = null
		if(tarifaMax != null){precioMaximo = new Double(tarifaMax)}
		
		var Busqueda busqueda = new Busqueda(origen, destino, fechaDesde, fechaHasta, precioMaximo ,usr)
		VuelosRepositorio.instance.searchByBusqueda(busqueda)
		BusquedasRepositorio.getInstance.guardarBusquedas(busqueda)
		resultados = busqueda.getResultados
		if(resultados.isEmpty){resultados = null} //para la vista.
		var logs = new LogsRepository
		var consulta = new Consulta(busqueda)
		consulta.transformarLista(busqueda.resultados)
		logs.insertarConsulta(consulta)
	}
	
	def clear(){
		origen = null
		destino = null
		fechaDesde = null
		fechaHasta = null
		tarifaMax = null
	}
}