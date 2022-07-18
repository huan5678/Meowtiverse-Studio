import '../styles/globals.css';
import '@rainbow-me/rainbowkit/styles.css';
import type {AppProps} from 'next/app';
import {RainbowKitProvider, getDefaultWallets, lightTheme, darkTheme, midnightTheme} from '@rainbow-me/rainbowkit';
import {chain, configureChains, createClient, WagmiConfig} from 'wagmi';
import {alchemyProvider} from 'wagmi/providers/alchemy';
import {publicProvider} from 'wagmi/providers/public';
import {ChakraProvider} from '@chakra-ui/react';
import {useEffect, useState} from 'react';

const {chains, provider, webSocketProvider} = configureChains(
  [chain.rinkeby],
  [
    alchemyProvider({
      alchemyId: process.env.ALCHEMY_API_KEY,
    }),
    publicProvider(),
  ]
);

const {connectors} = getDefaultWallets({
  appName: 'RainbowKit App',
  chains,
});

const wagmiClient = createClient({
  autoConnect: true,
  connectors,
  provider,
  webSocketProvider,
});

function App({Component, pageProps}: AppProps) {
const [timeRange, setTimeRange] = useState('');

  useEffect(()=>{
    const darkmode = window.matchMedia("(prefers-color-scheme: dark)").matches;
    const time = new Date().getHours();
    if (darkmode) {
      return setTimeRange('midnight');
    }
    if (time < 6) {
      return setTimeRange('midnight');
    }
    if (time < 18) {
      return setTimeRange('day');
    }
    return setTimeRange('night');
  },[])

  return (
    <ChakraProvider>
      <WagmiConfig client={wagmiClient}>
        <RainbowKitProvider 
        appInfo={
          {
            appName: 'Meowtiverse Studio',
          }
        }
        chains={chains} 
        theme={
          timeRange === 'midnight' ? midnightTheme({
          overlayBlur: 'small'
        }) : timeRange === 'night' ? darkTheme({
          overlayBlur: 'small'
        }) : lightTheme({
          overlayBlur: 'small'
        })} coolMode>
          <Component {...pageProps} />
        </RainbowKitProvider>
      </WagmiConfig>
    </ChakraProvider>
  );
}

export default App;
