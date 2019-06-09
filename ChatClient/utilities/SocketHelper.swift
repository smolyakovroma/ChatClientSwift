
import Foundation
import SocketIO

class SocketHelper: NSObject {
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    static let sharedInstance = SocketHelper()
    
    override init() {
        //        let socketURL   = URL(string: "http://178.128.90.60")!
        //        let socketURL   = URL(string: "https://etzpokerserver.herokuapp.com:9092")!
//        let socketURL   = URL(string: "http://127.0.0.1:3000")!
          let socketURL   = URL(string: "http://192.168.0.102:3000")!
        let manager = SocketManager(socketURL: socketURL)
        self.manager = manager
        self.socket = manager.defaultSocket
        //        SocketHelper.socketHelper = self
    }
    
    
    func establishConnection() {
        socket.connect()
//        if !Constants.id.isEmpty {
//               SocketHelper.sharedInstance.subscribe(id: Constants.id)
//        }
      
        //      manager.connect()
    }
    
    func closeConnection() {
        print("disconnect")
//        socket.emit("leaveRooms", Player())
        socket.disconnect()
    }
    
//    func joinRoom(player: Player) {
//        print(player.balance)
//        socket.emit("joinRoom", player)
//
//    }
    
    func addUser(name: String, phone: String, email: String){
        self.socket.emit("adduser", with: [name, phone, email])
    }
    
    func showRooms(){
        self.socket.emit("showRooms", with: [])
    }
    
    func addRoom(name: String, idRoom: String){
        self.socket.emit("addroom", with: [name, idRoom])
    }
    
    func getRooms(name: String){
        self.socket.emit("getrooms", with: [name])
    }
    
    func getContacts(userId: String){
        self.socket.emit("getcontacts", with: [userId])
    }
    
    func addContact(userId: String, contactId: String, contactName: String){
        self.socket.emit("addcontact", with: [userId, contactId, contactName])
    }
    
    func sendMsg(userId: String, recipientId: String, chatId: String, msg: String){
        self.socket.emit("sendmsg", with: [userId, recipientId, chatId, msg])
    }
    
    func addChat(userId: String, recipientId: String){
        self.socket.emit("addchat", with: [userId, recipientId])
    }
    
    func getChats(userId: String){
        self.socket.emit("getchats", with: [userId])
    }
    
    func findContact(userId: String, name: String, phone: String){
        self.socket.emit("findcontact", with: [userId, name, phone])
    }
    
    func setLogo(id: String, avatar: String){
        self.socket.emit("setlogo", with: [id, avatar])
    }
    
    func getLogo(id: String){
        self.socket.emit("getlogo", with: [id])
    }
    
    func subscribe(id: String){
        self.socket.emit("subscribe", with: [id])
    }
    
//    func joinGame(player: Player ) {
//        socket.emit("joinGame", player)
//    }
    
//    func leaveRoom(player: Player ) {
//        socket.emit("leaveRoom", player)
//    }
}
