package Repositorios

import Dominio.Busqueda
import Dominio.Vuelo
import org.eclipse.xtend.lib.annotations.Accessors
import org.hibernate.Criteria
import org.hibernate.HibernateException
import org.hibernate.criterion.Restrictions
import org.uqbar.commons.utils.Observable

@Accessors
@Observable
class VuelosRepositorio extends RepositorioDefault<Vuelo> {

	static VuelosRepositorio repositorio = null

	static public def VuelosRepositorio getInstance() {
		if (repositorio == null) {
			repositorio = new VuelosRepositorio()
		}
		repositorio
	}

	def searchByBusqueda(Busqueda unaBusqueda) {
		val session = openSession
		try {
			val criteria = session.createCriteria(entityType)
			if(unaBusqueda.desdeFecha != null){criteria.add(Restrictions.ge("fechaSalida", unaBusqueda.desdeFecha))}// desdeBusqueda < salidaVuelo
			if(unaBusqueda.hastaFecha != null){criteria.add(Restrictions.le("fechaLlegada", unaBusqueda.hastaFecha))}// hastaBusqueda > llegadaVuelo
			if(unaBusqueda.origen != null) {criteria.add(Restrictions.eq("origen", unaBusqueda.origen))}
			if(unaBusqueda.destino != null) {criteria.add(Restrictions.eq("destino", unaBusqueda.destino))}
			if(unaBusqueda.maxPrecio != null){ criteria.createAlias("asientos", "asiento") // Por precio base
															.createAlias("asiento.tarifa", "tarifa")
															.add(Restrictions.le("tarifa.precio", unaBusqueda.maxPrecio))
			}
			
			unaBusqueda.setResultados(criteria.list.toSet)
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}
	
	override getEntityType() { typeof(Vuelo) }

	override addQueryByExample(Criteria criteria, Vuelo vuelo) {
		if (vuelo.origen != null) {
			criteria.add(Restrictions.eq("aerolinea", vuelo.aerolinea))
		}
	}
}

