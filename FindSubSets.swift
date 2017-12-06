import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arr = ["A", "B"]
        let myResult = arr.powerset.map { $0.sorted().joined(separator: "") }
        print(myResult)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension Array {
    var powerset: [[Element]] {
        guard count > 0 else {
            return [[]]
        }
        
        // tail contains the whole array BUT the first element
        let tail = Array(self[1..<endIndex])
        
        // head contains only the first element
        let head = self[0]
        
        // computing the tail's powerset
        let withoutHead = tail.powerset
        
        // mergin the head with the tail's powerset
        let withHead = withoutHead.map { $0 + [head] }
        
        // returning the tail's powerset and the just computed withHead array
        return withHead + withoutHead
    }
    
}
