//
//  StoryboardConstants.swift
//  octo-tap
//
//  Created by Lukas Valine on 7/18/17.
//  Copyright © 2017 Lukas Valine. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
	static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
	static var storyboardIdentifier: String {
		return String(describing: self)
	}
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
	enum Storyboard: String {
		case main
		var filename: String {
			return rawValue.capitalized
		}
	}
}


