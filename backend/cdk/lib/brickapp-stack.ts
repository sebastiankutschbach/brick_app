import { Stack, StackProps } from 'aws-cdk-lib';
import { LambdaIntegration, LambdaRestApi, RestApi, Stage, UsagePlan } from 'aws-cdk-lib/aws-apigateway';
import { Code, Function, Runtime } from 'aws-cdk-lib/aws-lambda';
import { Bucket } from 'aws-cdk-lib/aws-s3';
import { Secret } from 'aws-cdk-lib/aws-secretsmanager';
import { Construct } from 'constructs';
import * as path from 'path';

export class BrickAppStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const mocsBucket = Bucket.fromBucketName(this, 'mocs-bucket', 'brickapp-mocs');

    const mocsInstructionLister = new Function(this, 'moc-instruction-lister', {
      handler: 'index.handler',
      code: Code.fromAsset(path.join(__dirname, '/../../moc-instruction-lister')),
      runtime: Runtime.NODEJS_14_X,
    });
    mocsBucket.grantRead(mocsInstructionLister);

    const mocsInstructionProvider = new Function(this, 'moc-instruction-provider', {
      handler: 'index.handler',
      code: Code.fromAsset(path.join(__dirname, '/../../moc-instruction-provider')),
      runtime: Runtime.NODEJS_14_X,
    });
    mocsBucket.grantRead(mocsInstructionProvider);


    const restApi = new RestApi(this, 'rest-api', {
      deployOptions: {
        stageName: 'dev',
      },
      // 👇 enable CORS
      defaultCorsPreflightOptions: {
        allowHeaders: [
          'Content-Type',
          'X-Amz-Date',
          'Authorization',
          'X-Api-Key',
        ],
        allowMethods: ['OPTIONS', 'GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
        allowCredentials: true,
        allowOrigins: ['http://localhost:3000'],
      },
    });

    const sets = restApi.root.addResource('sets');
    const set = sets.addResource('{set}');
    set.addMethod('GET', new LambdaIntegration(mocsInstructionLister), {apiKeyRequired:true});

    const mocs = set.addResource('mocs');
    const moc = mocs.addResource('{moc}');
    moc.addMethod('GET', new LambdaIntegration(mocsInstructionProvider), {apiKeyRequired:true});

    const secret = new Secret(this, 'Secret', {
      secretName: 'brickapp-api-key',
      generateSecretString: {
        generateStringKey: 'api_key',
        secretStringTemplate: JSON.stringify({ username: 'brickapp' }),
        excludeCharacters: ' %+~`#$&*()|[]{}:;<>?!\'/@"\\',
      },
    });
    
    const apiKey = restApi.addApiKey('ApiKey', {
      apiKeyName: `brickapp-key`,
      value: secret.secretValueFromJson('api_key').toString(),
    });

    const usagePlan = new UsagePlan(this, 'api-usage-plan', {
      name: 'brickapp-api-usage-plan',
      throttle: {
        rateLimit: 10,
        burstLimit: 2
      }
    });

    usagePlan.addApiKey(apiKey);
    usagePlan.addApiStage({stage: restApi.deploymentStage});

  }
}
