package Dominio

import org.mongodb.morphia.annotations.Entity
import org.mongodb.morphia.annotations.Id
import org.bson.types.ObjectId
import org.mongodb.morphia.annotations.Property
import java.util.Set

import org.mongodb.morphia.annotations.Embedded
import java.util.Date
import java.util.HashSet
import org.mongodb.morphia.annotations.Transient

@Entity("consultas")
class Consulta {
	
	Set resultados = new HashSet
	
	@Id ObjectId id
	
	@Property("criterio")
	String criterio
	
	//@Embedded
	@Transient
	Set results
	
	new(Busqueda busqueda){
    criterio = busqueda.criterioDeBusqueda
    results = new HashSet
   // results = busqueda.resultados
    //this.transformarLista
    
 }
 
 def void transformarLista(Set resultados){
 	resultados.forEach[vuelo|results.add(new ResultadoConsulta(vuelo))]
 }
 



}