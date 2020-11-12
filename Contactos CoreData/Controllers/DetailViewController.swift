//
//  DetailViewController.swift
//  Contactos CoreData
//
//  Created by Jose Angel Cortes Gomez on 10/11/20.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Conexion a la DataBase
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Creacion del arreglo de tipo MyContact
    var contacts = [Contacts]()
    
    var name: String?
    var phone: Int64?
    var address: String?
    var index: Int?
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInfoCoreData()

        // Do any additional setup after loading the view.
        self.title = "Detalles"
        
        // Volver redondo el ImageView
        self.contactImageView.layer.masksToBounds = true
        self.contactImageView.layer.cornerRadius = self.contactImageView.bounds.width / 2
        
        self.nameTextField.text = name
        self.phoneTextField.text = String(phone ?? 0)
        self.addressTextView.text = address
    }
    
    
    @IBAction func changeImageContac(_ sender: UIButton) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    // MARK: Metodos de los delegados para el PickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagen = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage
        
        contactImageView.image = imagen
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChangesContactButton(_ sender: UIBarButtonItem) {
        
        // Sobre escribimos los nuevos datos en el contacto actual
        contacts[index!].setValue(nameTextField.text, forKey: "name")
        contacts[index!].setValue(Int64(phoneTextField.text!), forKey: "phone")
        contacts[index!].setValue(addressTextView.text, forKey: "address")
//        contacts[index!].setValue(contactImageView, forKey: "image")
        
        saveContact()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelChangesContactButton(_ sender: UIButton) {
        
        // Regresar al Controller anterior
        navigationController?.popViewController(animated: true)
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
