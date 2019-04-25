# Jimbo Test Challenge

# Quick Notes

The architecture of the project based on MVVM + Router and also divided into layers. Unfortunately, the Router is useless for this project as it has a single screen.

Layers: Application, Presentation, Services, Model, Core, Networking.

Components of each layer assemble by assembly files provided by Swinject framework (DI pattern), e.g ApplicationAssemly or TemplatesModuleAssembly.

The Presentation layer contains all the classes related to the user interface including: views, user storie modules, storyboards.

The User Story module is a bundle of ModuleAssembly, ViewController, ViewModel and Router classes. Each user story module is responsible for a single application screen or a complex view.

The Service layer is responsible for the business logic and networking requests.

The Networking client based on Alamofire framework. Endpoints classes: TemplatesListEndpoint, TemplateEndpoint.

Storage & Data Import. The Realm was picked as a database for a data cache. The data from API parses and imports in the background thread, in classes: TemplatesListParser, TemplateParser.
As the realm objects lists can be observed, the Templates screen updates itself automatically as soon as the data is imported to the realm storage. The TemplatesList is the observable list class.

UICollectionView & Views. The collection view has two states: a list of templates and a full screen template view. The state switches by tapping on the template preview cell and can be collapsed by the button on the top left corner.
All the logic related to the collection view (e.g. data source methods, delegate methods, list updates logic) is in the TemplatesDisplayDataManager.
The template variations picker described in the ThemePickerView class.

P.S. For the first look the project structure appears overcomplicated for the test challenge, with all its directories and subdirectories. But by this way, I wanted to show how I organize a structure in real projects which can contain 10 and more screens.

# Updated to v1.1

The app devided into two screens (modules). The Templates module becomes a parent for the main and details modules. The custom zoom animation was added to the pusn and pop action between screens.
