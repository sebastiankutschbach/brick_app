import lambda = require('@aws-cdk/aws-lambda-go');
import cdk = require('@aws-cdk/core');
import s3 = require('@aws-cdk/aws-s3');
import logs = require('@aws-cdk/aws-logs');

export class BrickAppStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    let downloadBucket = new s3.Bucket(this, 'DownloadBucket', {
      bucketName: 'brick-app-download-bucket',
    });
    
    const downloaderFunction = new lambda.GoFunction(this, 'Downloader', {
      entry: '../downloader/',
      memorySize: 128,
      timeout: cdk.Duration.seconds(10),
      environment: {'BUCKET' : downloadBucket.bucketName},
      logRetention: logs.RetentionDays.ONE_DAY
    })

    downloadBucket.grantReadWrite(downloaderFunction);
  }
}
