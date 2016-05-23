package Dominio

import java.text.SimpleDateFormat
import java.util.Date
import java.util.HashSet
import java.util.Set
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne
import javax.persistence.OneToMany
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable


@Entity
@Accessors
@Observable
class Vuelo {
	
	@Id
	@GeneratedValue
	private Long id
	
	@ManyToOne
	Aeropuerto origen

	@ManyToOne
	Aeropuerto destino

	@Column(length=150)
	String aerolinea

	@OneToMany(fetch=FetchType.EAGER, cascade=CascadeType.ALL)
	Set<Asiento> asientos = new HashSet

	@Column
	Date fechaSalida

	@Column
	Date fechaLlegada

	@OneToMany(fetch=FetchType.EAGER, cascade=CascadeType.ALL)
	Set<Escala> escalas = new HashSet
	
	transient static SimpleDateFormat dateToString = new SimpleDateFormat("dd/MM/yyyy - hh:mm 'hs'")

	new() {
	}

	def agregarEscala(Escala escala) {
		escalas.add(escala)
	}

	def getCantidadDeAsientosLibres() {
		asientos.filter[disponible].toList.size()
	}

	def conDestino(String destinoStr) {
		destino.nombre.equals(destinoStr)
	}

	def conOrigen(String origenStr) {
		origen.nombre.equals(origenStr)
	}

	def conTarifaMenorA(Double valor) {
		asientos.exists[conPrecioMaximo(valor)]
	}

	def asientosValorMaximo(Double valor) {
		asientos.filter[conPrecioMaximo(valor)].toList
	}

	def llegaAntesQue(Date unaFecha) {
		fechaLlegada.before(unaFecha)
	}

	def saleAntesQue(Date unaFecha) {
		fechaSalida.before(unaFecha)
	}

	def getNombreOrigen() { origen.nombre }

	def getNombreDestino() { destino.nombre }

	def getCantidadEscalas() { escalas.size }

	def getFechaSalidaStr() { dateToString.format(fechaSalida) }

	def getFechaLlegadaStr() { dateToString.format(fechaLlegada) }

}
