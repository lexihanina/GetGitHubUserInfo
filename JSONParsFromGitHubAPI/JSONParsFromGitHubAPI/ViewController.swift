//
//  ViewController.swift
//  JSONParsFromGitHubAPI
//
//  Created by Lexi Hanina on 28.01.24.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hireableLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var followingsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var reposLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    private var avatarImage: UIImage?
    private var blogUrlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let userForSearch = searchBar.text else {
            print("No search text")
            return
        }
        
        Task {
            do {
                let user = try await getUsersInfo(forUser: userForSearch)
                let userAvatarData = try await getUserAvatarBy(url: URL(string: user.avatarUrl))
                
                DispatchQueue.main.async {
                    self.avatarImage = UIImage(data: userAvatarData)
                    if let blogUrlString = user.blog {
                        self.blogUrlString = blogUrlString
                        self.blogLabel.textColor = .blue
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                        self.blogLabel.addGestureRecognizer(tapGesture)
                    }
                    self.fillViewWithDataFor(user: user)
                }
            } catch Errors.invalidURL {
                print("Invalid URL")
            } catch Errors.invalidSearch {
                print("Invalid Search")
            } catch Errors.invalidResponse {
                print("Invalid Response")
            } catch Errors.invalidData {
                print("Invalid Data")
            } catch {
                print ("Unexpected Error")
            }
        }
    }
    
    func getUsersInfo(forUser: String) async throws -> User {
        do {
            guard let url = URLBuilder().usersPath().exact(user: forUser).build() else {
                throw Errors.invalidURL
            }
            
            let data = try await NetworkManager.shared.makeGETRequest(withUrl: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(User.self, from: data)
            return decodedData
        } catch {
            throw Errors.invalidData
        }
    }
    
    func getUserAvatarBy(url: URL?) async throws -> Data {
        do {
            guard let url = url else { throw Errors.invalidAvatarURL }
            
            let data = try await NetworkManager.shared.makeGETRequest(withUrl: url)
            return data
        } catch {
            throw Errors.invalidAvatarData
        }
    }
    
    func fillViewWithDataFor(user: User) {
        usernameLabel.text = user.login
        avatar.image = avatarImage
        nameLabel.text = user.name ?? "No data"
        companyLabel.text = user.company ?? "No data"
        locationLabel.text = user.location ?? "No data"
        bioLabel.text = user.bio ?? "No data"
        emailLabel.text = user.email ?? "No data"
        blogLabel.text = user.blog ?? "No data"
        twitterLabel.text = user.twitterUsername ?? "No data"
        followingsLabel.text = String(user.following)
        followersLabel.text = String(user.followers)
        reposLabel.text = String(user.publicRepos)
        createdLabel.text = user.createdAt
        
        if let hireable = user.hireable {
            hireableLabel.text = hireable ? "Yes" : "No"
        } else {
            hireableLabel.text = "No data"
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let blogUrlString = blogUrlString, let url = URL(string: blogUrlString) {
            UIApplication.shared.open(url)
        }
    }
}
