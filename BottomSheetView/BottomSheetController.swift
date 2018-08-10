//
//  BottomSheetController.swift
//  BottomSheet
//
//  Copyright © 2018 Tim. All rights reserved.
//

import UIKit

@objc protocol BottomSheetDelegate {
	
	@objc func kTableView(_ tableView: UITableView, numberOfRowInSection section:Int) -> Int
	@objc func kTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	
	@objc optional func kTableView(_ taleView: UITableView, heightForRowAt indexPath: IndexPath)-> CGFloat
	@objc optional func kNumerOfSections(_ tableView: UITableView) -> Int
	@objc optional func kTableView(_ taleView: UITableView, didSelectRowAt indexPath: IndexPath)
	@objc optional func kTableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
	@objc optional func kTableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
	
	@objc optional func kRegisterNib(_ tableView: UITableView)
}

class BottomSheetController: UIViewController {
	
	@IBOutlet weak var shadowView: UIView!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var tableView: UITableView!
	
	
	let fullView: CGFloat = 0
	var originY: CGFloat = UIScreen.main.bounds.height - 250
	
	
	@objc weak var bottomSheetDelegate: BottomSheetDelegate?
	
	
	required init?(coder aDecoder: NSCoder) {		
		super.init(coder: aDecoder)
	}
	
	//MARK: Public method
	@objc func reloadData() {
		tableView.reloadData()
	}
	
	@objc func reloadRows(indexPaths: [IndexPath]) {
		tableView.reloadRows(at: indexPaths, with: .automatic)		
	}
	
	//MARK: - Init method
	private func initTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		
		
		self.bottomSheetDelegate?.kRegisterNib?(tableView)
		
		tableView.register(UINib.init(nibName: "DefaultCell", bundle: nil), forCellReuseIdentifier: DefaultCell.identify())
	}
	
	
	//MARK: - Life cycle
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		initTableView()
		
		
		let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetController.panGesture))
		gesture.delegate = self
		view.addGestureRecognizer(gesture)
		
		
	}
    
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		setCorner(view: shadowView)
		addShadow(view: self.view)
	}
    
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		UIView.animate(withDuration: 0.6, animations: { [weak self] in
			let frame = self?.view.frame
			let yComponent = self?.originY
			self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height )
		})
	}

	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	private func addShadow(view: UIView) {
		let offset = CGSize.init(width: 0, height: 20)
		view.layer.shadowOffset = offset;//陰影的位移量
		view.layer.shadowRadius = 5;//陰影的散射半徑
		view.layer.shadowOpacity = 0.5;//陰影的透明度1為不透明
		view.layer.shadowPath = UIBezierPath.init(roundedRect: view.bounds, cornerRadius: 20).cgPath//陰影實體路徑
		view.layer.shadowColor = UIColor.gray.cgColor;
		view.layer.masksToBounds = false;
	}
	
	private func setCorner(view: UIView) {
		let rectCorner = UInt8(UIRectCorner.topRight.rawValue) | UInt8(UIRectCorner.topLeft.rawValue)
		let rect = view.bounds
		let radio = CGSize.init(width: 15, height: 15)
		let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: UIRectCorner(rawValue: UInt(rectCorner)), cornerRadii: radio)
		let masklayer = CAShapeLayer.init()
		masklayer.frame = view.bounds;
		masklayer.path = path.cgPath;//設定路徑
		view.layer.mask = masklayer;
	}
	
	
	@objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
		
		let translation = recognizer.translation(in: self.view)
		let velocity = recognizer.velocity(in: self.view)
		
		let y = self.view.frame.minY
		if (y + translation.y >= fullView) && (y + translation.y <= originY) {
			self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
			recognizer.setTranslation(CGPoint.zero, in: self.view)
		}
        
		
		if recognizer.state == .ended {
			var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((originY - y) / velocity.y )
			
			duration = duration > 1.3 ? 1 : duration
            
			
			UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
				
				if  velocity.y >= 0 {
					self.view.frame = CGRect(x: 0, y: self.originY, width: self.view.frame.width, height: self.view.frame.height)
				} else {
					self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
				}
				
			}, completion: { [weak self] _ in
				if ( velocity.y < 0 ) {
					self?.tableView.isScrollEnabled = true
				}
			})
		}
	}
	

}

extension BottomSheetController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		let section = self.bottomSheetDelegate?.kNumerOfSections?(tableView) ?? 1
		
		return section
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let rows = self.bottomSheetDelegate?.kTableView(tableView, numberOfRowInSection: section) ?? 0
		
		return rows
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		
		let  h = self.bottomSheetDelegate?.kTableView?(tableView, heightForRowAt: indexPath) ?? 44
		return h
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = self.bottomSheetDelegate?.kTableView(tableView, cellForRowAt: indexPath)
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		self.bottomSheetDelegate?.kTableView?(tableView, didSelectRowAt: indexPath)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let h = self.bottomSheetDelegate?.kTableView?(tableView, heightForHeaderInSection: section) ?? 0
		return h
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = self.bottomSheetDelegate?.kTableView?(tableView, viewForHeaderInSection: section)
		return headerView
	}
}

extension BottomSheetController: UIGestureRecognizerDelegate {

	// Solution
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
		let direction = gesture.velocity(in: view).y
		
		let y = view.frame.minY
		if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (floorf(Float(y))  == floorf(Float(originY))) {
			tableView.isScrollEnabled = false
		} else {
			tableView.isScrollEnabled = true
		}
		
		return false
	}
    
}
