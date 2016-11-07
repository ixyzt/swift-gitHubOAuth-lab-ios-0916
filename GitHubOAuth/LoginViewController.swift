//
//  LoginViewController.swift
//  GitHubOAuth
//
//  Created by Joel Bell on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Locksmith
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    var safariViewController: SFSafariViewController!
    
    let numberOfOctocatImages = 10
    var octocatImages: [UIImage] = []
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImageViewAnimation()
        
        NotificationCenter.default.addObserver(_: self, selector: #selector(safariLogin), name: .closeSafariVC, object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginImageView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loginImageView.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureButton()

    }
    
    // MARK: Set Up View
    
    private func configureButton() {
        
        imageBackgroundView.layer.cornerRadius = 0.5 * self.imageBackgroundView.bounds.size.width
        imageBackgroundView.clipsToBounds = true
    }
    
    private func setUpImageViewAnimation() {
        
        for index in 1...numberOfOctocatImages {
            if let image = UIImage(named: "octocat-\(index)") {
                octocatImages.append(image)
            }
        }
        
        loginImageView.animationImages = octocatImages
        
        loginImageView.animationDuration = 2.0
        
    }
    
    func safariLogin(_ notification: Notification) -> () {
//        
        safariViewController.dismiss(animated: true)
        
        
        let notificationURL = notification.object as! URL
        print("\n\n\n++++++++++++++++++++  THIS IS THE NOTIFICATIONURL +++++++++++++++")
        print(notificationURL)
        print("++++++++++++++++++++  THIS IS THE NOTIFICATIONURL +++++++++++++++\n\n\n")
        
        GitHubAPIClient.request(.token(url: notificationURL)) { (json, starred, error) in
            if error == nil {
                NotificationCenter.default.post(name: .closeLoginVC, object: nil)
            }
        }
        
    }
    
    // MARK: Action
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        self.safariViewController = SFSafariViewController(url: GitHubRequestType.oauth.url)
        present(self.safariViewController, animated: true, completion: nil)
        
    }

}







