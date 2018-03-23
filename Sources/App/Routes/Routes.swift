import Vapor

class FlowerService {
    
    static var flowers :[Flower] = [Flower]()
    
}

class Flower : JSONRepresentable {
    
    var name :String!
    var description: String!
    var imageURL :String!
    
    init(name :String, description :String, imageURL :String) {
        self.name = name
        self.description = description
        self.imageURL = imageURL
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("name", self.name)
        try json.set("description",self.description)
        try json.set("imageURL",self.imageURL)
        return json
    }
}

extension Droplet {
    
    func setupRoutes() throws {
        
        post("flower") { req in
            
            guard let name = req.data["name"]?.string,
                let description = req.data["description"]?.string,
                let imageURL = req.data["imageURL"]?.string else {
                    fatalError("Parameters missing! ")
            }
            
            let flower = Flower(name: name, description: description, imageURL: imageURL)
            FlowerService.flowers.append(flower)
            
            var json = JSON()
            try json.set("success", true)
            
            return json
            
        }
        
        get("flowers") { req in
            
            let rose = Flower(name: "Rose", description: "The rose is a type of flowering shrub. Its name comes from the Latin word Rosa. The flowers of the rose grow in many different colors, from the well-known red rose or yellow roses and sometimes white or purple roses. Roses belong to the family of plants called Rosaceae", imageURL: "https://i.pinimg.com/originals/e2/b3/a0/e2b3a08d93d85ad1ed6b33890aa67f33.jpg")
            
            let lantana = Flower(name: "Lantana", description: "Small, perennial shrub with spiny, square stems; leaves simple, opposite or whorled, toothed, fragrant when crushed; flowers in flat-topped clusters on a long stalk, each flower small, tubular, 4-parted, white, pink, or yellow, changing to orange or red; fruit fleshy, green becoming bluish black", imageURL: "https://plants.ces.ncsu.edu/media/images/lantana_flower_Kathleen_Moore.JPG")
            
            let purpleHearts = Flower(name: "Purple Hearts", description: "Purple Heart is a trailing, tender perennial with purple stems and violet-purple leaves that produces pink flowers in summer. This plant is mainly grown for its foliage (leaves can reach 7 inches in length); best color is achieved in bright sunlight and a dry, cramped root zone.", imageURL: "https://i.pinimg.com/736x/17/5d/a8/175da8e69839a1d3e835a7442e07bbdd--purple-heart-plant-purple-hearts.jpg")
            
            if FlowerService.flowers.isEmpty {
                FlowerService.flowers.append(rose)
                FlowerService.flowers.append(lantana)
                FlowerService.flowers.append(purpleHearts)
            }
            
            return try FlowerService.flowers.makeJSON()
            
        }
        
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }
        
        get("plaintext") { req in
            return "Hello, world!"
        }
        
        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }
        
        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}

