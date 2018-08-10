//
//  ViewController.swift
//  BottomSheetView
//
//  Created by mtaxi on 2018/8/7.
//  Copyright © 2018年 Tim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BottomSheetDelegate {
	
	private func initBottomSheetView() {
		
		let bottomController = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetController") as! BottomSheetController
		bottomController.bottomSheetDelegate = self
		self.addChildViewController(bottomController)
		self.view.addSubview(bottomController.view)
		bottomController.didMove(toParentViewController: self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		initBottomSheetView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	//MARK: BottomSheetDelegate
	func kRegisterNib(_ tableView: UITableView) {
		tableView.register(UINib.init(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: TestCell.identify())
	}
	
	func kTableView(_ tableView: UITableView, numberOfRowInSection section: Int) -> Int {
		return 5
	}
	
	func kTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: TestCell.identify(), for: indexPath)
		return cell
	}


}

