import UIKit
import SnapKit

class LaunchScreen: UIViewController {
    
    let lorby: UILabel = {
        let label = UILabel()
        label.text = "Lorby"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tutor: UILabel = {
        let label = UILabel()
        label.text = "Твой личный репетитор"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lorbyIconImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "lorbyIcon")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.navigateToAuthorizationView()
        }
    }
    
    func setUI(){
        view.addSubview(lorby)
        view.addSubview(tutor)
        view.addSubview(lorbyIconImage)
        
        lorby.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(162)
            make.centerX.equalToSuperview()
        }
        
        tutor.snp.makeConstraints { make in
            make.top.equalTo(lorby.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        lorbyIconImage.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-220)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
    }
    
    func navigateToAuthorizationView() {
        let authorizationVC = AuthorizationViewController(viewModel: AuthorizationViewModel())
        navigationController?.setViewControllers([authorizationVC], animated: true)
    }
}
