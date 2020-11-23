//
//  ViewController.swift
//  Contactos CoreData
//
//  Created by Jose Angel Cortes Gomez on 10/11/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // Conexion a la DataBase
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Creacion del arreglo de tipo MyContact
    var contacts = [Contacts]()
    
    var nameContact: String?
    var phoneContact: Int64?
    var addressContact: String?
    var imageContact: Data?
    var index: Int?

    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.title = "Contactos"
        
        TableView.dataSource = self
        TableView.delegate = self
//        TableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        loadInfoCoreData()
    }
    
    // Actualizar la data al regresar al ViewController una vez que se actuliza el contacto
    override func viewWillAppear(_ animated: Bool) {
        loadInfoCoreData()
        TableView.reloadData()
    }

    @IBAction func AddContact(_ sender: UIBarButtonItem) {
        
        // Creaccion del Alert
        let alert = UIAlertController(title: "Agregar Contacto", message: "Crear un nuevo contacto", preferredStyle: .alert)
        
        // Creacion de Textfield
        alert.addTextField { (nameAlert) in
            nameAlert.placeholder = "Nombre"
        }
        alert.addTextField { (phoneAlert) in
            phoneAlert.placeholder = "Telefono"
        }
        alert.addTextField { (addressAlert) in
            addressAlert.placeholder = "Direccion"
        }
        
        // Creacion del Alert Aceptar y Cancelar
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let actionAlert = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            
            // Variables para almacenar el contacto
            guard let nameAlert = alert.textFields?.first?.text else { return }
            guard let phoneAlert = alert.textFields?[1].text else { return }
            guard let addressAlert = alert.textFields?.first?.text else { return }
            
            // Recuperamos una imagen por default desde los Assets
            let image = UIImage(named: "Perfil")

            // Insertar en DataBase
            let newContact = Contacts(context: self.context)
            newContact.name = nameAlert
            newContact.phone = Int64 (phoneAlert) ?? 0
            newContact.address = addressAlert
            newContact.image = image?.jpegData(compressionQuality: 0.5)
            
            self.contacts.append(newContact)
            self.saveContact()
            self.TableView.reloadData()
        }
        
        // Añadir Actions al Alert
        alert.addAction(actionAlert)
        alert.addAction(actionCancel)
        
        // Presentacion del alert
        present(alert, animated: true, completion: nil)
    }
    
    // Funcion para guardar contacto en DataBase
    func saveContact(){
        
        // Try Catch para almacenar contacto en DataBase
        do {
            try context.save()
            print("contacto agregado")
        } catch let error as NSError{
            print("Error al guardar en DataBase \(error.localizedDescription)")
        }
    }
    
    // Obtiene la informacion de la Database y se almacena en el arreglo Contatcs
    func loadInfoCoreData() {
        
        // Peticion de busqueda
        let fetchRequest : NSFetchRequest <Contacts> = Contacts.fetchRequest()
        
        // Try Catch para cargar contactos de DataBase
        do {
            contacts = try context.fetch(fetchRequest)
        } catch let error as NSError{
            print("Error al cargar en DataBase \(error.localizedDescription)")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Funcion para visualizar las celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    // Funcion para eliminar un elemento del TableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            context.delete(contacts[indexPath.row])
            contacts.remove(at: indexPath.row)
            saveContact()
        }
        
        tableView.reloadData()
    }
    
    // Funcion para el contenido de las celdas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row].name
        cell.detailTextLabel?.text = String (contacts[indexPath.row].phone)
        return cell
        
//        let objCeldaPer = TableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTableViewCell
//
//        // Modificar el texto de nuestros renglones del TableView
//        objCeldaPer.nameCellLabel?.text = contacts[indexPath.row].name
//        objCeldaPer.detailCellLabel?.text = String (contacts[indexPath.row].phone)
//
//        return objCeldaPer
    }
    
    // Deseleccionar la fila seleccionada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Obtener el valor de la celda para buscar los datos en CoreData
        let cell = sender as! UITableViewCell
        let indexPath = self.TableView.indexPath(for: cell)
        
        nameContact = contacts[indexPath!.row].name
        phoneContact = contacts[indexPath!.row].phone
        addressContact = contacts[indexPath!.row].address
        imageContact = contacts[indexPath!.row].image
        index = indexPath!.row
        
        
        if segue.identifier == "DetailContact" {
            let secondView = segue.destination as! DetailViewController
            secondView.name = nameContact
            secondView.phone = phoneContact
            secondView.address = addressContact
            secondView.image = imageContact
            secondView.index = index
        }
    }
}
