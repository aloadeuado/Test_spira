# Test_spira

La aplicaicon es una lista de recetas para seleccionar su favorita y el punto de origen de la receta

## CONTRUCCION MIDWARE

- Para empezar creamos un ep [spira/api/registerOrAuth](http://44.215.48.103:5002/spira/api/registerOrAuth) donde de manera sencilla la misma pantalla de autenticacion no sirve para registrar el usuario

request
```javascript
{"email": "example@mail.com",
"token": "id_social_net", // solo se envia si te autenticas con google
"password": "contrase"} //si digitas un correo diferente a gmail
```
response
```javascript
{"data"{"email": "example@mail.com",
"token": "id_social_net", // solo se envia si te autenticas con google
"password": "contrase"}} //si digitas un correo diferente a gmail
```

nota: se considero generar un token para autenticacion por medio de Headers pero se descarto por se runa test app

- Para el registro de favoritos el ep [/spira/api/addTextSearch](http://44.215.48.103:5002/spira/api/registerOrAuth) donde por medio del id del usuario asignaremos los favoritos los textos se guardaran siempre y cuando ovtengan resultados de la parte de recetas

request
```javascript
{"idUder": "id",
"text": "back"} //si digitas un correo diferente a gmail
```
response
```javascript
{
  "data": [
    "jft",
    "man",
    "back"
  ]
}
```
Nota: cabe aclarar que mucha de la logica de negocio no se hizo en el back como deberia y recomiendo hacerse pero esto es con el fin de potenciar el reto en front incluso cosas como favoritos esta contruido de forma local

## Manejo de local storage
- Contemplando la posibilidad de utilizar manejo de almacenamiento interno como userDefaults ketChain o incluso coreData se decidio irse por el lado de UserDEfault por si flesibilidad con #DB NOSQL
- esto se puede apreciar en todo el flujo de agregar o quitar como favorito un item

## Manejo de git (git flow)
- en principio se p[enso en hacer una rama de despliegue para dev, qa, prd pero vieno la agilidad de prueba solo se dejo develop para dev y main para prd y qa

Nota: cabe aclarar que mucha de la logica de negocio no se hizo en el back como deberia y recomiendo hacerse pero esto es con el fin de potenciar el reto en front incluso cosas como favoritos esta contruido de forma local

- aca como ejemplo se deja el manejo de la iterancia de la existencia de id en local y en servicio de localizaicones guardadas y por medio de herramientas de ampliar el eprformace se itera entre las listas de favoritos y listas de localizaicones para saber donde esta le corazon prendido o apagado y cuales recetas tienen una localizacion asignada

```swift
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identificador, for: indexPath) as? ProductCollectionViewCell {
                cell.showSkeletor()
                return cell
            }
        }
        if isFavoriteProducts {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identificador, for: indexPath) as? ProductCollectionViewCell {
                cell.hidSkeletor()
                if let listProducts = listProducts {
                    cell.setData(result: listFavoritesProducts[indexPath.row])
                    let isFavorite = viewModel?.getListFavoriteProductsIds().first(where: { result1 in
                        return result1.id == listFavoritesProducts[indexPath.row].id
                    }) != nil
                    cell.isFavorite = isFavorite
                    cell.datum = locationModel?.data?.data?.first(where: { datum in
                        datum.idRecipe == listFavoritesProducts[indexPath.row].id
                    })
                    cell.isLocationExist = cell.datum != nil
                }
                cell.delegate = self
                
                return cell
            }
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identificador, for: indexPath) as? ProductCollectionViewCell {
            cell.hidSkeletor()
            if let result = listProducts {
                cell.setData(result: result[indexPath.row])
                let isFavorite = viewModel?.getListFavoriteProductsIds().first(where: { result1 in
                    return result1.id == result[indexPath.row].id
                }) != nil
                cell.isFavorite = isFavorite
                cell.datum = locationModel?.data?.data?.first(where: { datum in
                    datum.idRecipe == result[indexPath.row].id
                })
                cell.isLocationExist = cell.datum != nil
            }
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
```
- para la parte de los productos se utiliza el api de [https://fakestoreapi.com/](https://fakestoreapi.com) 

## Manejo de local storage
- Contemplando la posibilidad de utilizar manejo de almacenamiento interno como userDefaults ketChain o incluso coreData se decidio irse por el lado de UserDEfault por si flesibilidad con #DB NOSQL
- esto se puede apreciar en todo el flujo de agregar o quitar como favorito un item

## Manejo de git (git flow)
- en principio se p[enso en hacer una rama de despliegue para dev, qa, prd pero vieno la agilidad de prueba solo se dejo develop para dev y main para prd y qa con el que se levanta ramas feature por cada avance 
la parte de hotfix y integracion queda en la capa de revision pero al final si se hace la liberacion desde develop a prd(main)
![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testpira-eec30.appspot.com/o/Captura%20de%20pantalla%202023-04-30%20a%20la(s)%206.38.54%20p.m..png?alt=media&token=07ac6bed-7a04-4447-bc7e-a374b2c07f55)

## Installation

Use cocoa pods [cocoapods](https://cocoapods.org/) he instala los pods de dependencias .

```bash
pod install
```

## Dependencias Usadas

```javascript
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'test_yape_ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'GoogleSignIn', '~> 6.2.4'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SDWebImage', '~> 5.13.2'
  pod 'SkeletonView', '~> 1.30.4'

  target 'test_yape_iosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'test_yape_iosUITests' do
    # Pods for testing
  end

end
```

- SDWebImage: descargar imagenes y menejo de cache para su reconsumo posteriormente.
- SkeletonView: para la evidencia de fragmento de desgradado mientras trae los datos o responde en EndPoint seleccionado.

- nota: al terminar de agregar los pods selecciona del los schemas el de testSpira_dev o testSpira como en la imagen
![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testpira-eec30.appspot.com/o/Captura%20de%20pantalla%202023-04-30%20a%20la(s)%206.42.20%20p.m..png?alt=media&token=ef15a2e4-0c38-40b4-8d51-dafabc295a2c)

## Arquitectura usada
- mvvm: la idea es la implementación de [POP](https://medium.com/globallogic-latinoamerica-mobile/la-programaci%C3%B3n-orientada-a-protocolos-en-swift-3548ed2dc2f1) conjunto con un viewModel con los protocolos
```swift
import Foundation
import UIKit

protocol ListProductsViewToViewModel {
    func succesGetListProducts(listProducts: [ProductOfList], text: String)
    func successGetListText(textModel: TextModel)
    func successGetListText(locationModel: LocationModel)
    func showError(error: String)
}

protocol ListProductsViewModelToView: AnyObject {
    func getListProducts(controller: UIViewController, text: String, numberPerPage: Int)
    func addTextFastSearch(text: String)
    func getLocationData()
}

```
- y por medio de binding se entregar los resuelto en los servicios para las vistas

```swift
///MARK: -ListProductsViewModelToView
extension ListProductsViewModel: ListProductsViewModelToView {
    func getListProducts(controller: UIViewController, text: String, numberPerPage: Int) {
        
        Products.getListProducts(numberOfItems: numberPerPage) { [weak self] success, listProducts, error in
            if success {
                guard let self = self, let listProducts = listProducts else {return}
                if text.isEmpty {
                    self.listProductsViewToViewModel?.succesGetListProducts(listProducts: listProducts, text: text)
                    return
                }
                var listProductFilter = [ProductOfList]()
                listProductFilter = listProducts.filter({ productOfList in
                    print("\(productOfList.title ?? "") text: \(text) cumple: \((productOfList.title ?? "").contains(text.lowercased()))")
                    return (productOfList.title?.lowercased() ?? "").contains(text.lowercased())
                })
                
                self.listProductsViewToViewModel?.succesGetListProducts(listProducts: listProductFilter, text: text)
                return
                
            } else {
                controller.view.makeToast(error)
            }
        }
    }
    
    func getLocationData() {
        
        LocationsWS.getLocationProduct() {[weak self] successs, locationData, error in
            guard let self = self else {return}
            if let locationData = locationData {
                self.listProductsViewToViewModel?.successGetListText(locationModel: locationData)
            }
        }

    }
    
    func addTextFastSearch(text: String) {
        SearchWS.createTextSearch(text: text, email: UserDefault.getDefaultUser()?.data?.email ?? "") { [weak self] success, textModel, error in
            guard let self = self else {return}
            if let textModel1 = textModel, let error = textModel1.error {
                self.listProductsViewToViewModel?.showError(error: error)
            } else if let textModel1 = textModel {
                self.listProductsViewToViewModel?.successGetListText(textModel: textModel1)
            } else {
                self.listProductsViewToViewModel?.showError(error: "Ha ocurrido un error")
            }
        }
    }
    
    func getTextFastSearch(){
        SearchWS.getTextSearch(email: UserDefault.getDefaultUser()?.data?.email ?? "") { [weak self] success, textModel, error in
            guard let self = self else {return}
            if let textModel1 = textModel, let error = textModel1.error {
                self.listProductsViewToViewModel?.showError(error: error)
            } else if let textModel1 = textModel {
                self.listProductsViewToViewModel?.successGetListText(textModel: textModel1)
            } else {
                self.listProductsViewToViewModel?.showError(error: "Ha ocurrido un error")
            }
        }
    }
    
    func getListFavoriteProductsIds() -> [ProductOfList] {
        return FavoriteDefault.getFavoriteProduct()
    }
    
    func addAndRemoveFavoriteId(result: ProductOfList) {
        FavoriteDefault.addFavoriteProduct(result: result)
    }
    
    func getListPage(listProducts: [ProductOfList]) -> [String] {
        
        
        return ["0...5", "0...10", "0...15", "all"]
    }
}

```
- se agrego una arquitectura repository para el manejo de storage
- una clase de trato de data dependiendo de la necesidad del negocio
```swift
import Foundation
import UIKit

class ApiServices {
    enum Method : String {
        case post = "POST"
        case put = "PUT"
        case get = "GET"
        case patch = "PATCH"
    }
    
    func requestHttpwithUrl<T : Codable>(EpUrl: String, method: ApiServices.Method, withData parameters: [String:Any], modelType:T.Type, completionHandler: @escaping (Bool, T?, Error?) -> Void) {
        
        let request_url = URL(string: EpUrl)
        
        let request:NSMutableURLRequest = NSMutableURLRequest()
        print("[URL REQUEST=>]: \(request_url)")
        print("[PARAMETERS=>]: \(parameters)")
        request.url = request_url
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        if method != .get {
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData
        }
        let session = URLSession.init(configuration: .default)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            let response = (response as? HTTPURLResponse)
            print("[CODE STATUS=>]: \(response)")
            if response?.statusCode == 200 {
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let textJson = String(decoding: safeData, as: UTF8.self)
                        print("[RESPONSE=>]: \(textJson)")
                        let decodedData = try decoder.decode(modelType, from: safeData)
                        DispatchQueue.main.async {
                            completionHandler(true, decodedData, nil)
                        }
                    } catch let error{
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            completionHandler(false, nil, error)
                        }
                    }
                }else{
                    print("[ERROR=>]: \(error?.localizedDescription ?? "")")
                    DispatchQueue.main.async {
                        completionHandler(false, nil, error)
                    }
                }
            }else{
                print("[ERROR=>]: \(error?.localizedDescription ?? "")")
                if let safeData = data{
                    let textJson = String(decoding: safeData, as: UTF8.self)
                    print("[RESPONSE=>]: \(textJson)")
                    let decoder = JSONDecoder()
                    DispatchQueue.main.async {
                        completionHandler(false, nil, nil)
                    }
                }else{
                    completionHandler(false, nil, nil)
                }
            }
        })
        task.resume()
    }
}

```

- y una etapa de encapsulamiento mas dedicada al negocio
```swift
import Foundation

struct Products {
    static func getListProducts(numberOfItems: Int, complete: @escaping ((Bool, [ProductOfList]?, String) -> Void)) {
        let url = getListProducstUrl().replacingOccurrences(of: "&{number}", with: "\(numberOfItems)")
        
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: [:], modelType: [ProductOfList].self) { success, listProduct, error in
            DispatchQueue.main.async {
                complete(success, listProduct, error?.localizedDescription ?? "")
            }
        }
    }
    
    static func getDetailProduct(idProduct: Int, complete: @escaping ((Bool, ProductOfList?, String) -> Void) ) {
        let url = getDetailProductUrl().replacingOccurrences(of: "&{idProduct}", with: "\(idProduct)")
        
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: [:], modelType: ProductOfList.self) { success, detailProduct, error in
            DispatchQueue.main.async {
                complete(success, detailProduct, error?.localizedDescription ?? "")
            }
        }
    }
}
```
- y por medio del viewModel nos comunicamos con las vista.

```swift
import Foundation
import UIKit
class ListProductsViewModel {
    var listProductsViewToViewModel: ListProductsViewToViewModel?
    init(listProductsViewToViewModel: ListProductsViewToViewModel) {
        self.listProductsViewToViewModel = listProductsViewToViewModel
    }
}
//MARK: -ListProductsViewModelToView
extension ListProductsViewModel: ListProductsViewModelToView {
    func getListProducts(controller: UIViewController, text: String, numberPerPage: Int) {
        
        Products.getListProducts(numberOfItems: numberPerPage) { [weak self] success, listProducts, error in
            if success {
                guard let self = self, let listProducts = listProducts else {return}
                if text.isEmpty {
                    self.listProductsViewToViewModel?.succesGetListProducts(listProducts: listProducts, text: text)
                    return
                }
                var listProductFilter = [ProductOfList]()
                listProductFilter = listProducts.filter({ productOfList in
                    print("\(productOfList.title ?? "") text: \(text) cumple: \((productOfList.title ?? "").contains(text.lowercased()))")
                    return (productOfList.title?.lowercased() ?? "").contains(text.lowercased())
                })
                
                self.listProductsViewToViewModel?.succesGetListProducts(listProducts: listProductFilter, text: text)
                return
                
            } else {
                controller.view.makeToast(error)
            }
        }
    }
    
    func getLocationData() {
        
        LocationsWS.getLocationProduct() {[weak self] successs, locationData, error in
            guard let self = self else {return}
            if let locationData = locationData {
                self.listProductsViewToViewModel?.successGetListText(locationModel: locationData)
            }
        }

    }
    
    func addTextFastSearch(text: String) {
        SearchWS.createTextSearch(text: text, email: UserDefault.getDefaultUser()?.data?.email ?? "") { [weak self] success, textModel, error in
            guard let self = self else {return}
            if let textModel1 = textModel, let error = textModel1.error {
                self.listProductsViewToViewModel?.showError(error: error)
            } else if let textModel1 = textModel {
                self.listProductsViewToViewModel?.successGetListText(textModel: textModel1)
            } else {
                self.listProductsViewToViewModel?.showError(error: "Ha ocurrido un error")
            }
        }
    }
    
    func getTextFastSearch(){
        SearchWS.getTextSearch(email: UserDefault.getDefaultUser()?.data?.email ?? "") { [weak self] success, textModel, error in
            guard let self = self else {return}
            if let textModel1 = textModel, let error = textModel1.error {
                self.listProductsViewToViewModel?.showError(error: error)
            } else if let textModel1 = textModel {
                self.listProductsViewToViewModel?.successGetListText(textModel: textModel1)
            } else {
                self.listProductsViewToViewModel?.showError(error: "Ha ocurrido un error")
            }
        }
    }
    
    func getListFavoriteProductsIds() -> [ProductOfList] {
        return FavoriteDefault.getFavoriteProduct()
    }
    
    func addAndRemoveFavoriteId(result: ProductOfList) {
        FavoriteDefault.addFavoriteProduct(result: result)
    }
    
    func getListPage(listProducts: [ProductOfList]) -> [String] {
        
        
        return ["0...5", "0...10", "0...15", "all"]
    }
}


```
## Manejo de Generics
- se tomo la decicion de junto con el JSONDECODE manejar Generics para la deserializacion de informacion

```swift
func requestHttpwithUrl<T : Codable>(EpUrl: String, method: ApiServices.Method, withData parameters: [String:Any], modelType:T.Type, completionHandler: @escaping (Bool, T?, Error?) -> Void) {
        
        let request_url = URL(string: EpUrl)
        
        let request:NSMutableURLRequest = NSMutableURLRequest()
        print("[URL REQUEST=>]: \(request_url)")
        print("[PARAMETERS=>]: \(parameters)")
        request.url = request_url
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        if method != .get {
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData
        }
        let session = URLSession.init(configuration: .default)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            let response = (response as? HTTPURLResponse)
            print("[CODE STATUS=>]: \(response)")
            if response?.statusCode == 200 || response?.statusCode == 201 {
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let textJson = String(decoding: safeData, as: UTF8.self)
                        print("[RESPONSE=>]: \(textJson)")
                        let decodedData = try decoder.decode(modelType, from: safeData)
                        DispatchQueue.main.async {
                            completionHandler(true, decodedData, nil)
                        }
                    } catch let error{
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            completionHandler(false, nil, error)
                        }
                    }
                }else{
                    print("[ERROR=>]: \(error?.localizedDescription ?? "")")
                    DispatchQueue.main.async {
                        completionHandler(false, nil, error)
                    }
                }
            } else if response?.statusCode == 400 {
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let textJson = String(decoding: safeData, as: UTF8.self)
                        print("[RESPONSE=>]: \(textJson)")
                        let decodedData = try decoder.decode(modelType, from: safeData)
                        DispatchQueue.main.async {
                            completionHandler(true, decodedData, nil)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            completionHandler(false, nil, error)
                        }
                    }
                }else{
                    print("[ERROR=>]: \(error?.localizedDescription ?? "")")
                    DispatchQueue.main.async {
                        completionHandler(false, nil, error)
                    }
                }
            } else {
                print("[ERROR=>]: \(error?.localizedDescription ?? "")")
                if let safeData = data{
                    let textJson = String(decoding: safeData, as: UTF8.self)
                    print("[RESPONSE=>]: \(textJson)")
                    let decoder = JSONDecoder()
                    DispatchQueue.main.async {
                        completionHandler(false, nil, nil)
                    }
                }else{
                    completionHandler(false, nil, nil)
                }
            }
        })
        task.resume()
    }
```

## Depliegue continuo(CD)
- se contemplo utilizar [fastlane](https://fastlane.tools/) pero al final nos fuimos por [bitrise](https://app.bitrise.io/) por que por medio de cajones por debamos nos construye nuestro documento [fastlane](https://fastlane.tools/)

- empezamos con la configuracion del proyecto seleccion del repo y la rama

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testyummy-26178.appspot.com/o/Captura%20de%20Pantalla%202021-10-26%20a%20la(s)%2012.20.37%20a.%C2%A0m..png?alt=media&token=162e5d7a-01f1-4b8b-9365-e4d773ec2cf8)

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testyummy-26178.appspot.com/o/Captura%20de%20Pantalla%202021-10-26%20a%20la(s)%2012.21.26%20a.%C2%A0m..png?alt=media&token=b32dbbed-f91e-49fa-ace2-a8f31a9b0896)

- al terminar la configuración encontraremos un dashboard con el resumen de nuestra configuración

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testyummy-26178.appspot.com/o/Captura%20de%20Pantalla%202021-10-26%20a%20la(s)%2012.22.40%20a.%C2%A0m..png?alt=media&token=b2fe0b65-072f-4c74-b1bd-b123d2e70496)

- posteriormente podemos empezar a gregar cajones que por debajo configuran nuestra fastlane o incluso otras herramientas

- en este caso agregaremos una de [firebase distribution](https://firebase.google.com/?gclid=CjwKCAjwq9mLBhB2EiwAuYdMtU3Cg_kLyrNm1v0lD4kAFiKr2atanP8hXV7_ifKCnyOyJ_uNDFPenBoC8NAQAvD_BwE&gclsrc=aw.ds)

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testyummy-26178.appspot.com/o/Captura%20de%20Pantalla%202021-10-26%20a%20la(s)%2012.27.45%20a.%C2%A0m..png?alt=media&token=8705c329-f616-484a-a26a-4bb627b0aa65)

- configuramos nuestra consola de firebase
- agregamos los correos a los que queremos liberar la version qa en develop segun ambiente


- y cada vez que hagamos un pull request a nuestra rama qa tendremos automáticamente un build con las características de workflow ya construidas


## Usuario y contraseña de prueba

- user: test@mail.com
- password: 12345678


## Video demostrativo Lista Productos

[![IMAGE ALT TEXT HERE](https://firebasestorage.googleapis.com/v0/b/testpira-eec30.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%202023-04-30%20at%2018.48.54.png?alt=media&token=7779974b-fea8-4926-96bd-f3334857109c)](https://firebasestorage.googleapis.com/v0/b/testpira-eec30.appspot.com/o/Simulator%20Screen%20Recording%20-%20iPhone%2011%20Pro%20Max%20-%202023-04-30%20at%2018.49.52.mp4?alt=media&token=4d576a80-e2e9-4d08-90da-cfab9cd59bf6)

## Video demostrativo Detalle Productos

[![IMAGE ALT TEXT HERE](https://firebasestorage.googleapis.com/v0/b/testpira-eec30.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%202023-04-30%20at%2018.49.01.png?alt=media&token=837f5ef2-b752-4cc9-8ef8-15fcdfcad4c1)](https://firebasestorage.googleapis.com/v0/b/testpira-eec30.appspot.com/o/Simulator%20Screen%20Recording%20-%20iPhone%2011%20Pro%20Max%20-%202023-04-30%20at%2018.50.10.mp4?alt=media&token=ca532236-b43e-4677-bc13-7e911f2f742b)

