//
//  TemplatesService.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/16/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation

class TemplatesService {

    let networkingClient: NetworkingClient

    init(networkingClient: NetworkingClient) {
        self.networkingClient = networkingClient
    }

    func set(variation: TemplateVariationRM, for template: TemplateRM, skip tokens: [DataStackRM.Token]) {
        try! DataStackRM.write({
            template.selectedVariation = variation
        }, withoutNotifying: tokens)
    }

    func templatesList(completion: @escaping (Result<[TemplateRM]>)->()) {
        let endpoint = TemplatesListEndpoint.templatesList
        self.networkingClient.request(endpoint, resultType: [TemplateRM].self) {
            result in
            completion(result)
        }
    }

    func templateDetails(identifier: String, completion: @escaping (Result<TemplateRM>)->()) {
        guard let object = DataStackRM.realm.object(ofType: TemplateRM.self, forPrimaryKey: identifier) else {
            completion(Result.failure(nil))
            return
        }
        let endpoint = TemplateEndpoint.template(identifier: identifier, urlPath: object.url)
        self.networkingClient.request(endpoint, resultType: TemplateRM.self, completion: {
            result in
            if result.isFailure && !object.isLoaded {
                try! DataStackRM.write ({
                    object.shouldReload = true
                })
            }
            completion(result)
        })
    }

}
