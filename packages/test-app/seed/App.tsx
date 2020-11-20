import React, { Component } from 'react'
import { StyleSheet, Text, View, Image, TouchableOpacity } from 'react-native'
import AicactusSDK from '@tvpsoft/aicactus-sdk-react-native'

type Call = ['identify' | 'track', string, {}]

const calls: Call[] = require('./calls.json')

const Button = ({ title, onPress }: { title: string; onPress: () => void }) => (
  <TouchableOpacity style={styles.button} onPress={onPress}>
    <Text style={styles.text}>{title}</Text>
  </TouchableOpacity>
)

const screenHome = () => AicactusSDK.screen('Home')

const flush = () => AicactusSDK.flush()

const pizzaEaten = () => AicactusSDK.track('Pizza Eaten')

const trackOrder = () => {
  AicactusSDK.track('Order Completed')
  AicactusSDK.track('Order Cancelled', {
    order_id: 323
  })
  AicactusSDK.identify('userIdOnly')
  AicactusSDK.identify('userId', {
    age: 32
  })
  AicactusSDK.alias('newlyAliasedId')
  AicactusSDK.screen('User Login Screen', {
    method: 'google'
  })
}

const logAnonymousId = async () => {
  console.log('anonymousId: %s', await AicactusSDK.getAnonymousId())
}

const buildId = 'CIRCLE_WORKFLOW_ID'

const testSuite = () =>
  calls.forEach(([call, name, props = {}]) =>
  AicactusSDK[call](name, {
      ...props,
      buildId
    })
  )

export default class App extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Image
          source={{ uri: 'https://i.imgur.com/GrCdId0.png' }}
          resizeMode="contain"
          style={{
            margin: 50,
            width: 240,
            height: 160
          }}
        />
        <Button title="Screen: Home" onPress={screenHome} />
        <Button title="Track: Order Complete" onPress={trackOrder} />
        <Button title="Flush" onPress={flush} />
        <Button title="Track: Pizza Eaten" onPress={pizzaEaten} />
        <Button title="Launch test suite" onPress={testSuite} />
        <Button title="Log anonymousId" onPress={logAnonymousId} />
      </View>
    )
  }
}

const styles = StyleSheet.create({
  button: {
    margin: 20
  },
  text: {
    color: '#FBFAF9'
  },
  container: {
    flex: 1,
    justifyContent: 'flex-start',
    alignItems: 'center',
    backgroundColor: '#32A75D'
  }
})

import integrations from './integrations.gen'

AicactusSDK
    .setup('AICACTUS_WRITE_TOKEN', {
      debug: true,
      using: integrations
    })
    .then(() => console.log('Analytics ready'))
    .catch(err => console.error(err))
