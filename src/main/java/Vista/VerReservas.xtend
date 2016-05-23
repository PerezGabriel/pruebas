package Vista

import AppModel.BusquedaVueloAppModel
import AppModel.VerReservasAppModel
import Dominio.Reserva
import org.uqbar.arena.aop.windows.TransactionalDialog
import org.uqbar.arena.bindings.NotNullObservable
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.Dialog
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import AppModel.LogConsultasAppModel

class VerReservas extends TransactionalDialog<VerReservasAppModel>{
	
	new(WindowOwner parent, VerReservasAppModel model) {
		super(parent, model)	
		title = "Reservas"
	}
	
	override protected createFormPanel(Panel mainPanel) {
		
		new Panel(mainPanel) => [
			layout = new ColumnLayout(1)
			new Label(it).text = "Usuario: " + this.getModelObject.usuario.nombre
		]
		
		new Label(mainPanel).text = "Reservas Efectuadas"
		
        new Table<Reserva>(mainPanel, typeof(Reserva)) => [
			items <=> "usuario.reservas"
			height = 200
            bindSelectionToProperty("reservaSeleccionada")
            numberVisibleRows = 10
       		 		  				    
			new Column<Reserva>(it) => [
					title = "Origen" 
				    fixedSize = 100  
					bindContentsToProperty("origen")  
			]
			
			new Column<Reserva>(it) => [			
					title = "Destino" 
				    fixedSize = 100   
					bindContentsToProperty("destino")  	
			]	
			
			new Column<Reserva>(it) => [
					title = " Salida" 
				    fixedSize = 100   
					bindContentsToProperty("fechaSalida")  
			]
			new Column<Reserva>(it) => [
					title = "Llegada"
				    fixedSize = 100  
					bindContentsToProperty("fechaLlegada") 
			]		
				   
			new Column<Reserva>(it) => [
					title = "Tramos"
				    fixedSize = 100  
					bindContentsToProperty("tramos") 
			]		   
	        
	       new Column<Reserva>(it) => [
					title = "Asiento Reservado"
				    fixedSize = 50  
					bindContentsToProperty("asientoDescripcion") 
			]
		]
		
		val botonera = new Panel(mainPanel).layout = new HorizontalLayout
		
		new Button(botonera) => [
			caption = "Cancelar Reserva"
			width = 150
			onClick[|modelObject.cancelarReserva(modelObject.reservaSeleccionada)]
			bindEnabled(new NotNullObservable("reservaSeleccionada"))
		]
		
		val botonera2 = new Panel(mainPanel).layout = new HorizontalLayout
		new Button(botonera2) => [
		    setCaption = "Busqueda de Vuelos"
			width = 150
			onClick[|this.busqueda]
		]
			
        new Button(botonera2) => [
		    setCaption = "Log de Consultas Hechas"
			width = 150
			onClick[|this.consultas]
		] 
		
		new Button(botonera2) => [
			width = 80
			caption = "Salir"
			onClick [| this.accept]
		]       					
	}
	
	def consultas() {
		this.openDialog(new LogConsultas(this, new LogConsultasAppModel(modelObject.usuario)))
	}
	
	def busqueda(){
		this.openDialog(new BusquedaVuelo(this, new BusquedaVueloAppModel(modelObject.usuario)))
	}
	
	def openDialog(Dialog<?> dialog) {
		dialog.open
	}
	
	override protected addActions(Panel actionsPanel) {}
}