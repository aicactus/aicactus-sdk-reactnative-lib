const forceRequire = (): typeof import('../bridge') => {
	jest.resetModules()

	return require.requireActual('../bridge')
}

it('should throw an error if the core native module is not linked', () => {
	jest.setMock('react-native', {
		NativeModules: {}
	})

	expect(forceRequire).toThrow(/Failed to load Analytics native module./)
})

it('should export the core native module', () => {
	const RNAicactus = {}

	jest.setMock('react-native', {
		NativeModules: { RNAicactus }
	})

	expect(forceRequire().default).toBe(RNAicactus)
})
