import * as lambdaGo from '@aws-cdk/aws-lambda-go';
import * as cdk from '@aws-cdk/core';
import * as lambda from '@aws-cdk/aws-lambda';
import * as s3 from '@aws-cdk/aws-s3';
import * as logs from '@aws-cdk/aws-logs';
import * as lambdaEventSources from '@aws-cdk/aws-lambda-event-sources';

export class BrickAppStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    let downloadBucket = new s3.Bucket(this, 'DownloadBucket', {
      bucketName: 'brick-app-download-bucket',
    });

    const downloaderFunction = new lambdaGo.GoFunction(this, 'Downloader', {
      entry: '../downloader/',
      memorySize: 128,
      timeout: cdk.Duration.seconds(10),
      environment: {'BUCKET' : downloadBucket.bucketName},
      logRetention: logs.RetentionDays.ONE_DAY
    })

    downloadBucket.grantReadWrite(downloaderFunction);

    const importerFunction = new lambdaGo.GoFunction(this, 'Importer', {
      entry: '../importer/',
      memorySize: 128,
      timeout: cdk.Duration.seconds(10),
      logRetention: logs.RetentionDays.ONE_DAY,
    });

    const objectCreatedEvent = new lambdaEventSources.S3EventSource(downloadBucket, {
      events: [
        s3.EventType.OBJECT_CREATED
      ]
    });

    importerFunction.addEventSource(objectCreatedEvent);
  }
}
 