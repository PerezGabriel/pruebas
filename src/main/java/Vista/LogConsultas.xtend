package Vista

import AppModel.LogConsultasAppModel
import Dominio.Busqueda
import org.uqbar.arena.aop.windows.TransactionalDialog
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner

class LogConsultas extends TransactionalDialog<LogConsultasAppModel> {

	new(WindowOwner owner, LogConsultasAppModel model) {
		super(owner, model)
		title = "Log de Consultas Realizadas"
	}

	override protected createFormPanel(Panel mainPanel) {
		panelDeBusqueda(mainPanel)
		botoneraAcciones(mainPanel)
		tablaResultados(mainPanel)
	}

	def panelDeBusqueda(Panel mainPanel) {

		new Panel(mainPanel) => [
			layout = new ColumnLayout(3)
			new Label(it).text = "Sale despues de:"
			new Label(it).text = "Llega antes de:"
			new Label(it).text = "* formato mm/dd/aaaa"
			new TextBox(it) => [
				bindValueToProperty("fechaDesde")
				width = 100
			]
			new TextBox(it) => [
				bindValueToProperty("fechaHasta")
				width = 100
			]
			new Panel(it) => [
				layout = new HorizontalLayout
				new Button(it) => [
					caption = "Buscar"
					onClick [|modelObject.buscar]
					setAsDefault
					width = 80
				]
				new Button(it) => [
					caption = "Limpiar Campos"
					onClick [|modelObject.clear]
				]
			]
		]
	}

	def tablaResultados(Panel mainPanel) {
		new Table<Busqueda>(mainPanel, typeof(Busqueda)) => [
			bindItemsToProperty("resultados")
			bindSelectionToProperty("busquedaSeleccionada")
			height = 250
			numberVisibleRows = 8
			new Column<Busqueda>(it) => [
				title = "Fecha"
				fixedSize = 100
				bindContentsToProperty("fechaRealizacionStr")
			]
			new Column<Busqueda>(it) => [
				title = "Criterio de Busqueda"
				fixedSize = 100
				bindContentsToProperty("criterioDeBusqueda")
			]
			new Column<Busqueda>(it) => [
				title = "Vuelos"
				fixedSize = 128
				bindContentsToProperty("cantidadDeResultados")
			]
		]
	}

	def botoneraAcciones(Panel mainPanel) {

		val Panel panel = new Panel(mainPanel).layout = new HorizontalLayout()
		
		new Button(panel) => [
			width = 100
			caption = "Volver"
			onClick [|this.accept]
		]
		
		val resultados = new NotNullObservable("resultados")
		new Button(panel) => [
			width = 100
			caption = "Limpiar Grilla"
			onClick [|modelObject.resultados = null]
			bindEnabled(resultados)
		]
		
		new Button(panel) => [
			caption = "Detalles de la Busqueda"
			width = 150
			onClick[this.resultadosDeLaBusqueda]
			bindEnabled(new NotNullObservable("busquedaSeleccionada"))
		]

	}

	def resultadosDeLaBusqueda() {
		this.openDialog(new DetalleDeBusqueda(this, modelObject.busquedaSeleccionada))
	}

	def openDialog(Dialog<?> dialog) {
		dialog.open
	}
}
