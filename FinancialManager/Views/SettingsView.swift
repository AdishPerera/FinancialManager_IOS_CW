import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @AppStorage("uid") var userID: String = ""
    @AppStorage("email") var email: String = "" // Add AppStorage for user's email
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color.red) // Change the circle color as desired
                
                Text(String(email.prefix(1)).uppercased())
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 20)
            
            Text(email)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    withAnimation {
                        userID = ""
                    }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }) {
                Text("Sign Out")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(colors: [
                                    Color("Gradient1"),
                                    Color("Gradient2"),
                                    Color("Gradient3"),
                                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                    }
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
