package service

import (
	"demo/src/config"
	"demo/src/consts"
	"demo/src/output"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"log"
	"time"
)

func RequestPhotosRecursively() {

	// 替换以下内容为你的 AWS 访问凭证
	accessKeyID := "ASIAULQIPMQXED4PEW53"
	secretAccessKey := "Js95mnd5wWiNu3Jh+gABicaSdJHZz84ZVvqXekow"
	region := "us-east-1" // 根据你的 S3 存储桶所在的 AWS 区域调整 region

	// 创建一个 AWS Session
	sess, err := session.NewSession(&aws.Config{
		Region:      aws.String(region),
		Credentials: credentials.NewStaticCredentials(accessKeyID, secretAccessKey, ""),
	})
	if err != nil {
		log.Fatalf("Failed to create session: %v", err)
	}

	// 创建 S3 服务客户端
	svc := s3.New(sess)

	// 替换为你要访问的 S3 存储桶名称
	bucketName := "dhaiuhwoiwnxiwue"

	// 列出 S3 存储桶中的对象
	resp, err := svc.ListObjectsV2(&s3.ListObjectsV2Input{
		Bucket: aws.String(bucketName),
	})
	if err != nil {
		log.Fatalf("Failed to list objects: %v", err)
	}

	// 打印存储桶中的对象信息
	fmt.Println("Objects in the bucket:")
	for _, item := range resp.Contents {
		fmt.Println(*item.Key)
	}

	go func() {
		// create ticker
		interval := time.Duration(config.GetYamlConfig().System.TimeInterval) * time.Second
		ticker := time.NewTicker(interval)
		defer ticker.Stop()

		// run circle
		InformEMR()
		for {
			select {
			case <-ticker.C:
				InformEMR()
			}
		}
	}()
}

func InformEMR() {
	output.Print(consts.Service, "inform EMR to get camera images")
}
