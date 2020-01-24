import Foundation
import Alamofire
import ObjectMapper
class ApiHelper {
    public class func getData(inputParameters: [String: Any], onSuccess: @escaping (_ code: Int, _ message: String, _ apiResponse: [ApiResponseModel]) -> Void, onError: @escaping (_ code: Int, _ titleText: String, _ message: String) -> Void) {
        
        var url = ""
        
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
       
        if NetworkCheck.isConnectedToNetwork() == false {
            onError(101, "No Internet Connection", "Make sure your device is connected to the Internet.")
        } else {
            DispatchQueue.main.async {
                Alamofire.request(url).responseObject { (response: DataResponse<ApiResponseModel>) in
                    switch response.result {
                    case .failure(let error):
                        // calling error function
                        onError(10, "", error.localizedDescription)
                    case .success:
                        let apiResponse = response.result.value
                        let status = Int((apiResponse?.status)!)
                        // checking if Response code in 200 which is success
                        if apiResponse?.status == "1" {
                            
                            //calling on success method
                            onSuccess(status!, (apiResponse?.message)!, apiResponse)
                        } else {
                            //calling on Error method
                            onError(status!, "", apiResponse!.message!)
                        }
                    }
                    
                }
                
            }
            
        }
    }
}
