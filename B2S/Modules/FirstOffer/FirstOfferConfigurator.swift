//
//  FirstOfferConfigurator.swift
//  B2S
//
//  Created Egor Sakhabaev on 05.07.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//

import UIKit

struct FirstOfferConfigurator {
    
    static func createModule(with offer: Offer) -> UIViewController {
        let storyboard = UIStoryboard(name: "FirstOffer", bundle: Bundle(for: FirstOfferViewController.self))
        guard let storyboardViewController = storyboard.instantiateInitialViewController() else {
            fatalError("FirstOffer.storyboard has no initial view controller")
        }
        
        let viewController: UIViewController?
        if storyboardViewController is UINavigationController {
            viewController = (storyboardViewController as? UINavigationController)?.viewControllers.first
        } else {
            viewController = storyboardViewController
        }
        viewController?.modalPresentationStyle = .fullScreen
        
        guard let view = viewController as? FirstOfferViewController else {
            fatalError("Failed to cast to FirstOfferViewController")
        }
        
        let interactor = FirstOfferInteractor()
        let router = FirstOfferRouter()
        let presenter = FirstOfferPresenter(interface: view, interactor: interactor, router: router, offer: offer)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return storyboardViewController
    }
}