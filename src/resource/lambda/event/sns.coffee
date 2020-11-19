
import resource						from '../../../feature/resource'
import { GetAtt, Sub, isFn, isArn }	from '../../../feature/cloudformation/fn'

export default resource (ctx) ->

	postfix = ctx.string 'Postfix'
	topic	= ctx.string 'Topic'

	if not isFn(topic) and not isArn(topic)
		topic = Sub "arn:aws:sns:${AWS::Region}:${AWS::AccountId}:#{ topic }"

	ctx.addResource "#{ ctx.name }SnsSubscription#{ postfix }", {
		Type: 'AWS::SNS::Subscription'
		Properties: {
			TopicArn: topic
			Protocol: 'lambda'
			Endpoint: GetAtt ctx.name, 'Arn'
		}
	}

	ctx.addResource "#{ ctx.name }SnsLambdaPermission#{ postfix }", {
		Type: 'AWS::Lambda::Permission'
		Properties: {
			FunctionName: GetAtt ctx.name, 'Arn'
			Action:	'lambda:InvokeFunction'
			Principal: 'sns.amazonaws.com'
			SourceArn: topic
		}
	}
