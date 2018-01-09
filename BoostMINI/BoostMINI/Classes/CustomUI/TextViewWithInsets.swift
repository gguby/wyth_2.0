//
//  TextViewWithInsets.swift
//  BoostMINI
//
//  Created by  KoMyeongbu on 2018. 1. 8..
//  Copyright © 2018년 IRIVER LIMITED. All rights reserved.
//

import UIKit

//스토리 보드에서 패딩 수정 할수 있는 텍스트뷰
@IBDesignable class TextViewWithInsets: UITextView {
    
    @IBInspectable var topInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsetsMake(topInset, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)
        }
    }
    
    @IBInspectable var bottmInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, bottmInset, self.contentInset.right)
        }
    }
    
    @IBInspectable var leftInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsetsMake(self.contentInset.top, leftInset, self.contentInset.bottom, self.contentInset.right)
        }
    }
    
    @IBInspectable var rightInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom, rightInset)
        }
    }
}
