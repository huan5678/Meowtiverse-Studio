import {Box, Button} from '@chakra-ui/react';
import {ConnectButton} from '@rainbow-me/rainbowkit';
export const ConnectWallet = () => {
  return (
    <ConnectButton.Custom>
      {({account, chain, openAccountModal, openChainModal, openConnectModal, mounted}) => {
        return (
          <Box
            {...(!mounted && {
              'aria-hidden': true,
              style: {
                opacity: 0,
                pointerEvents: 'none',
                userSelect: 'none',
              },
            })}
          >
            {(() => {
              if (!mounted || !account || !chain) {
                return (
                  <Button
                    bgGradient="linear(to-br, pink.300, purple.500)"
                    color="white"
                    px="6"
                    size="lg"
                    onClick={openConnectModal}
                    sx={{
                      shadow: '0 2px 0 var(--chakra-colors-purple-600)',
                    }}
                    _hover={{
                      transform: 'scale(1.05)',
                      bgGradient: 'linear(to-br, pink.500, purple.700)',
                    }}
                    _active={{
                      transform: 'scale(.9)',
                    }}
                    type="button"
                  >
                    連接錢包
                  </Button>
                );
              }
              return (
                <Box style={{display: 'flex', gap: 12}}>
                  <Button
                    onClick={openChainModal}
                    style={{display: 'flex', alignItems: 'center'}}
                    type="button"
                  >
                    {chain.hasIcon && (
                      <Box
                        style={{
                          background: chain.iconBackground,
                          width: 12,
                          height: 12,
                          borderRadius: 999,
                          overflow: 'hidden',
                          marginRight: 4,
                        }}
                      >
                        {chain.iconUrl && (
                          <img
                            alt={chain.name ?? 'Chain icon'}
                            src={chain.iconUrl}
                            style={{width: 12, height: 12}}
                          />
                        )}
                      </Box>
                    )}
                    {chain.name}
                  </Button>
                  <Button onClick={openAccountModal} type="button">
                    {account.displayName}
                    {account.displayBalance ? ` (${account.displayBalance})` : ''}
                  </Button>
                </Box>
              );
            })()}
          </Box>
        );
      }}
    </ConnectButton.Custom>
  );
};
