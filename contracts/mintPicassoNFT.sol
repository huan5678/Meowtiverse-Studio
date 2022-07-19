// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract mintPicassoNFT is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    string public baseURI = "ipfs://你的baseURI"; // 這一行是 NFT 該去哪裡找你的 MetaData
    bool public paused = false; // 可以拿來暫停或者開啟 Mint
    uint256 public cost = 0.0001 ether; // Mint 價格
    uint256 public maxSupply = 5; // 只有五個 NFT
    uint256 public maxMintAmount = 1; // 一次最多只能 Mint 一個

    constructor() payable ERC721("PicassoAbstract", "PA") {
        // 剛開始我們先自己 Mint 一個
        safeMint(msg.sender, 5);
    }

    // 不用經過我們自己設定的判斷直接 Mint(設定為 private 且只有 onlyOwner 可以使用)
    function safeMint(address to, uint256 tokenId) private onlyOwner {
        _safeMint(to, tokenId);
    }

    // 提供給大家 Mint 的 Function(另外加上 payable 代表這個 function 可以接收乙太幣)
    function mint(address _to, uint256 _mintAmount) public payable {
        require(paused != true, "Sale must be active"); // 合約必須不是暫停
        require(_mintAmount > 0); // 每次必須鑄造超過 0 個
        require(
            _mintAmount <= maxMintAmount,
            "You can only adopt 1 PicassoAbstract at a time"
        ); // 鑄造的數量不可以大於每次最大鑄造數量
        require(
            cost * _mintAmount <= msg.value,
            "Ether value sent is not correct"
        ); // Mint 的價格不可以少於我們訂定的價格

        for (uint256 i = 0; i < _mintAmount; i++) {
            uint256 mintIndex = _tokenIdCounter.current();
            // 查看接下來要 Mint 的 NFT 是否有人持有了，如果已經持有就跳過
            while (_exists(mintIndex)) {
                i++;
            }

            // 接下來如果 Mint NFT 的編號如果小於初始提供的數量就讓使用者 Mint
            if (mintIndex <= maxSupply) {
                _safeMint(_to, mintIndex);
                _tokenIdCounter.increment();
            }
        }
    }

    // 重新設定 baseURI
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    // 取得這個持有者有多少 NFT
    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    // 查看使用者持有的 NFT MetaDate
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = baseURI;
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        "/",
                        Strings.toString(tokenId),
                        ".json"
                    )
                )
                : "";
    }

    // 查看總提供數量
    function totalSupply() public view override returns (uint256) {
        return maxSupply;
    }

    // 重新設定 Mint 價格
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    // 重新設定總提供量
    function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
        maxSupply = _newMaxSupply;
    }

    // 重新設定一次能 Mint 的數量
    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    // 開關販賣開關
    function pause() public onlyOwner {
        paused = !paused;
    }
}
