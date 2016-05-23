package Repositorios

import Dominio.Busqueda
import Dominio.Usuario
import java.util.Date
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

@Accessors
@Observable
class BusquedasRepositorio {
	static BusquedasRepositorio repositorio = null

	List<Busqueda> todasLasBusquedas = newArrayList

	static public def BusquedasRepositorio getInstance() {
		if (repositorio == null) {
			repositorio = new BusquedasRepositorio()
		}
		repositorio
	}

	def guardarBusquedas(Busqueda busqueda) {
		todasLasBusquedas.add(busqueda)
	}

	def buscar(Usuario usr, Date fechaDesde, Date fechaHasta) {
		
		filtrarPorFechaHasta(fechaHasta,
			filtrarPorFechaDesde(fechaDesde,
				filtrarPorUsuario(usr, todasLasBusquedas) ) )
	}

	def filtrarPorFechaHasta(Date fecha, List<Busqueda> busquedas) {
		if (fecha != null) {busquedas.filter[fechaRealizacion <= fecha].toList}
		else { busquedas }
	}

	def filtrarPorFechaDesde(Date fecha, List<Busqueda> busquedas) {
		if (fecha != null) {busquedas.filter[fechaRealizacion >= fecha].toList}
		else { busquedas }
	}

	def filtrarPorUsuario(Usuario usuario, List<Busqueda> busquedas) {
		if (usuario != null) {busquedas.filter[quienBusca.equals(usuario)].toList}
		else { busquedas }
	}

}
