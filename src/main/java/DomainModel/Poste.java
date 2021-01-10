package DomainModel;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "POSTES")
public class Poste {
	private String id;
	private String nomPoste;
	private String tempsUtilisation;
	private String periodeUtilisation;
	private int nombreActivations;
	
	@Id
	@Column(name = "ID")
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	@Basic
	@Column(name = "NOM_POSTE")
	public String getNomPoste() {
		return nomPoste;
	}
	public void setNomPoste(String nomPoste) {
		this.nomPoste = nomPoste;
	}
	
	@Basic
	@Column(name = "TEMPS_UTILISATION")
	public String getTempsUtilisation() {
		return tempsUtilisation;
	}
	public void setTempsUtilisation(String tempsUtilisation) {
		this.tempsUtilisation = tempsUtilisation;
	}
	
	@Basic
	@Column(name = "PERIODE_UTILISATION")
	public String getPeriodeUtilisation() {
		return periodeUtilisation;
	}
	public void setPeriodeUtilisation(String periodeUtilisation) {
		this.periodeUtilisation = periodeUtilisation;
	}
	
	@Basic
	@Column(name = "NOMBRE_ACTIVATIONS")
	public int getNombreActivations() {
		return this.nombreActivations;
	}
	public void setNombreActivations(int nombreActivations) {
		this.nombreActivations = nombreActivations;
	}
}
